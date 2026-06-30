package org.apache.ofbiz.customermgmt

import org.apache.ofbiz.entity.condition.EntityCondition
import org.apache.ofbiz.entity.condition.EntityOperator
import org.apache.ofbiz.entity.condition.EntityFunction
import org.apache.ofbiz.entity.util.EntityUtil
import org.apache.ofbiz.base.util.UtilDateTime
import org.apache.ofbiz.entity.GenericValue
import org.apache.ofbiz.service.ServiceUtil
import java.sql.Timestamp

/**
 * Search for customers using email, name, phone, or address filters.
 */
Map findCustomer() {
    Map resultMap = success()
    List searchConds = []
    
    // First, find the matching party IDs using the filters
    if (parameters.emailAddress) {
        searchConds.add(EntityCondition.makeCondition('contactMechPurposeTypeId', EntityOperator.EQUALS, 'EmailPrimary'))
        searchConds.add(EntityCondition.makeCondition(EntityFunction.upperField('infoString'), EntityOperator.LIKE, '%' + parameters.emailAddress.toUpperCase() + '%'))
    }
    if (parameters.firstName) {
        searchConds.add(EntityCondition.makeCondition(EntityFunction.upperField('firstName'), EntityOperator.LIKE, '%' + parameters.firstName.toUpperCase() + '%'))
    }
    if (parameters.lastName) {
        searchConds.add(EntityCondition.makeCondition(EntityFunction.upperField('lastName'), EntityOperator.LIKE, '%' + parameters.lastName.toUpperCase() + '%'))
    }
    if (parameters.contactNumber) {
        searchConds.add(EntityCondition.makeCondition('contactMechPurposeTypeId', EntityOperator.EQUALS, 'PRIMARY_PHONE'))
        searchConds.add(EntityCondition.makeCondition(EntityFunction.upperField('contactNumber'), EntityOperator.LIKE, '%' + parameters.contactNumber.toUpperCase() + '%'))
    }
    if (parameters.address1) {
        searchConds.add(EntityCondition.makeCondition('contactMechPurposeTypeId', EntityOperator.EQUALS, 'PRIMARY_LOCATION'))
        searchConds.add(EntityCondition.makeCondition(EntityFunction.upperField('address1'), EntityOperator.LIKE, '%' + parameters.address1.toUpperCase() + '%'))
    }

    searchConds.add(EntityUtil.getFilterByDateExpr())

    // Query matching parties
    List<GenericValue> searchResults = from('FindCustomerView').where(searchConds).queryList()
    List<String> partyIds = searchResults.collect { it.partyId }.unique()

    if (!partyIds) {
        resultMap.customerList = []
        return resultMap
    }

    // Now, query all contact mechs for the matched parties to aggregate their details
    List<GenericValue> rawList = from('FindCustomerView')
        .where(EntityCondition.makeCondition('partyId', EntityOperator.IN, partyIds))
        .queryList()

    // De-duplicate by partyId and aggregate email, phone, and address details
    Map uniqueParties = [:]
    for (GenericValue item : rawList) {
        String partyId = item.partyId
        if (!uniqueParties.containsKey(partyId)) {
            uniqueParties[partyId] = [
                partyId: item.partyId,
                statusId: item.statusId,
                firstName: item.firstName,
                lastName: item.lastName,
                emailAddress: '',
                contactNumber: '',
                address1: '',
                city: ''
            ]
        }
        Map partyData = uniqueParties[partyId]
        if (item.contactMechPurposeTypeId == 'EmailPrimary') {
            partyData.emailAddress = item.infoString
        } else if (item.contactMechPurposeTypeId == 'PRIMARY_PHONE') {
            partyData.contactNumber = item.contactNumber
        } else if (item.contactMechPurposeTypeId == 'PRIMARY_LOCATION') {
            partyData.address1 = item.address1
            partyData.city = item.city
        }
    }

    // We only want parties that have an EmailPrimary to count as our Customers
    List customerList = uniqueParties.values().findAll { it.emailAddress }

    // If searching by email specifically, filter to ensure only the matched email customer is returned
    if (parameters.emailAddress) {
        customerList = customerList.findAll { it.emailAddress.toLowerCase().contains(parameters.emailAddress.toLowerCase()) }
    }

    resultMap.customerList = customerList
    return resultMap
}

/**
 * Create a new customer record.
 */
Map createCustomer() {
    Map resultMap = success()

    // 1. Check if customer already exists using the findCustomer service
    Map findResult = run service: 'findCustomer', with: [emailAddress: parameters.emailAddress]
    if (findResult.customerList) {
        return error("Customer with email address [${parameters.emailAddress}] already exists.")
    }

    // 2. Create the base Person and Party (OOTB createPerson service handles both)
    Map createPersonResult = run service: 'createPerson', with: [
        firstName: parameters.firstName,
        lastName: parameters.lastName,
        statusId: 'PARTY_ENABLED'
    ]
    if (ServiceUtil.isError(createPersonResult)) {
        return createPersonResult
    }
    String partyId = createPersonResult.partyId

    // 3. Create and associate primary email contact mech
    Map emailResult = run service: 'createPartyEmailAddress', with: [
        partyId: partyId,
        emailAddress: parameters.emailAddress,
        contactMechPurposeTypeId: 'EmailPrimary'
    ]
    if (ServiceUtil.isError(emailResult)) {
        return emailResult
    }

    // 4. Assign CUSTOMER role to the new party
    run service: 'createPartyRole', with: [partyId: partyId, roleTypeId: 'CUSTOMER']

    resultMap.partyId = partyId
    return resultMap
}

/**
 * Update phone and/or address for a customer.
 */
Map updateCustomer() {
    Map resultMap = success()

    // 1. Locate the customer using the email address as unique identifier
    Map findResult = run service: 'findCustomer', with: [emailAddress: parameters.emailAddress]
    if (!findResult.customerList) {
        return error("Customer with email address [${parameters.emailAddress}] does not exist.")
    }
    String partyId = findResult.customerList[0].partyId

    // 2. Update/create Telecom Number if provided
    if (parameters.contactNumber) {
        GenericValue telecomMechPurpose = from('PartyContactMechPurpose')
            .where(partyId: partyId, contactMechPurposeTypeId: 'PRIMARY_PHONE')
            .filterByDate()
            .queryFirst()

        if (telecomMechPurpose) {
            run service: 'updatePartyTelecomNumber', with: [
                partyId: partyId,
                contactMechId: telecomMechPurpose.contactMechId,
                contactNumber: parameters.contactNumber,
                countryCode: parameters.countryCode,
                areaCode: parameters.areaCode
            ]
        } else {
            run service: 'createPartyTelecomNumber', with: [
                partyId: partyId,
                contactNumber: parameters.contactNumber,
                countryCode: parameters.countryCode,
                areaCode: parameters.areaCode,
                contactMechPurposeTypeId: 'PRIMARY_PHONE'
            ]
        }
    }

    // 3. Update/create Postal Address if provided
    if (parameters.address1) {
        GenericValue postalMechPurpose = from('PartyContactMechPurpose')
            .where(partyId: partyId, contactMechPurposeTypeId: 'PRIMARY_LOCATION')
            .filterByDate()
            .queryFirst()

        if (postalMechPurpose) {
            run service: 'updatePartyPostalAddress', with: [
                partyId: partyId,
                contactMechId: postalMechPurpose.contactMechId,
                address1: parameters.address1,
                address2: parameters.address2,
                city: parameters.city,
                postalCode: parameters.postalCode,
                stateProvinceGeoId: parameters.stateProvinceGeoId,
                countryGeoId: parameters.countryGeoId
            ]
        } else {
            run service: 'createPartyPostalAddress', with: [
                partyId: partyId,
                address1: parameters.address1,
                address2: parameters.address2,
                city: parameters.city,
                postalCode: parameters.postalCode,
                stateProvinceGeoId: parameters.stateProvinceGeoId,
                countryGeoId: parameters.countryGeoId,
                contactMechPurposeTypeId: 'PRIMARY_LOCATION'
            ]
        }
    }

    resultMap.partyId = partyId
    return resultMap
}

/**
 * Establish a relationship between two parties.
 */
Map createCustomerRelationship() {
    Map resultMap = success()
    String roleTypeIdFrom = parameters.roleTypeIdFrom ?: '_NA_'
    String roleTypeIdTo = parameters.roleTypeIdTo ?: '_NA_'

    // Ensure both parties have roles assigned to prevent constraint violations
    run service: 'ensurePartyRole', with: [partyId: parameters.partyIdFrom, roleTypeId: roleTypeIdFrom]
    run service: 'ensurePartyRole', with: [partyId: parameters.partyIdTo, roleTypeId: roleTypeIdTo]

    Timestamp fromDate = parameters.fromDate ?: UtilDateTime.nowTimestamp()

    GenericValue partyRelationship = makeValue('PartyRelationship', [
        partyIdFrom: parameters.partyIdFrom,
        partyIdTo: parameters.partyIdTo,
        roleTypeIdFrom: roleTypeIdFrom,
        roleTypeIdTo: roleTypeIdTo,
        partyRelationshipTypeId: parameters.partyRelationshipTypeId,
        fromDate: fromDate,
        statusId: 'PARTYREL_CREATED'
    ])
    partyRelationship.create()

    resultMap.fromDate = fromDate
    return resultMap
}

/**
 * Update the status of an existing party relationship.
 */
Map updateCustomerRelationship() {
    GenericValue partyRelationship = from('PartyRelationship')
        .where(
            partyIdFrom: parameters.partyIdFrom,
            partyIdTo: parameters.partyIdTo,
            roleTypeIdFrom: parameters.roleTypeIdFrom,
            roleTypeIdTo: parameters.roleTypeIdTo,
            fromDate: parameters.fromDate
        )
        .queryOne()

    if (!partyRelationship) {
        return error("Relationship not found.")
    }

    partyRelationship.statusId = parameters.statusId
    partyRelationship.store()

    return success()
}
