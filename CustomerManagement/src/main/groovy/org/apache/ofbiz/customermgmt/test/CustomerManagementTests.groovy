package org.apache.ofbiz.customermgmt.test

import org.apache.ofbiz.entity.GenericValue
import org.apache.ofbiz.service.ServiceUtil
import org.apache.ofbiz.service.testtools.OFBizTestCase

class CustomerManagementTests extends OFBizTestCase {

    CustomerManagementTests(String name) {
        super(name)
    }

    void testCustomerLifecycleAndRelationship() {
        String testEmail = "test_customer_" + System.currentTimeMillis() + "@example.com"
        
        // 1. Test Create Customer
        Map createCtx = [
            emailAddress: testEmail,
            firstName: "John",
            lastName: "Doe",
            userLogin: userLogin
        ]
        Map createResult = dispatcher.runSync("createCustomer", createCtx)
        assert ServiceUtil.isSuccess(createResult)
        String partyId1 = createResult.partyId
        assert partyId1 != null

        // Verify record existence
        GenericValue person1 = from("Person").where("partyId", partyId1).queryOne()
        assert person1 != null
        assert person1.firstName == "John"
        assert person1.lastName == "Doe"

        // 2. Test Duplicate Check
        Map dupResult = dispatcher.runSync("createCustomer", createCtx)
        assert ServiceUtil.isError(dupResult)

        // 3. Test Update Customer (Phone and Address)
        Map updateCtx = [
            emailAddress: testEmail,
            contactNumber: "1234567890",
            countryCode: "1",
            areaCode: "555",
            address1: "123 Main St",
            address2: "Suite 400",
            city: "New York",
            postalCode: "10001",
            stateProvinceGeoId: "NY",
            countryGeoId: "USA",
            userLogin: userLogin
        ]
        Map updateResult = dispatcher.runSync("updateCustomer", updateCtx)
        assert ServiceUtil.isSuccess(updateResult)

        // Verify updated contact mechs via FindCustomerView
        List<GenericValue> customerDetails = from("FindCustomerView")
            .where("partyId", partyId1, "contactMechPurposeTypeId", "EmailPrimary")
            .queryList()
        assert customerDetails != null && customerDetails.size() > 0
        // FindCustomerView might join phone/address if associated.
        // Let's verify via service findCustomer
        Map findResult = dispatcher.runSync("findCustomer", [emailAddress: testEmail, userLogin: userLogin])
        assert ServiceUtil.isSuccess(findResult)
        List customers = findResult.customerList
        assert customers != null && customers.size() == 1
        Map customer = customers[0]
        assert customer.contactNumber == "1234567890"
        assert customer.address1 == "123 Main St"

        // 4. Test Create second customer to link
        String testEmail2 = "test_customer_2_" + System.currentTimeMillis() + "@example.com"
        Map createResult2 = dispatcher.runSync("createCustomer", [
            emailAddress: testEmail2,
            firstName: "Jane",
            lastName: "Smith",
            userLogin: userLogin
        ])
        assert ServiceUtil.isSuccess(createResult2)
        String partyId2 = createResult2.partyId

        // 5. Test Create Relationship
        Map relCtx = [
            partyIdFrom: partyId1,
            partyIdTo: partyId2,
            partyRelationshipTypeId: "CUSTOMER_REL",
            roleTypeIdFrom: "CUSTOMER",
            roleTypeIdTo: "CUSTOMER",
            userLogin: userLogin
        ]
        Map relResult = dispatcher.runSync("createCustomerRelationship", relCtx)
        assert ServiceUtil.isSuccess(relResult)
        Date fromDate = relResult.fromDate
        assert fromDate != null

        // 6. Test Update Relationship Status
        Map updateRelCtx = [
            partyIdFrom: partyId1,
            partyIdTo: partyId2,
            roleTypeIdFrom: "CUSTOMER",
            roleTypeIdTo: "CUSTOMER",
            fromDate: fromDate,
            statusId: "PARTYREL_EXPIRED",
            userLogin: userLogin
        ]
        Map updateRelResult = dispatcher.runSync("updateCustomerRelationship", updateRelCtx)
        assert ServiceUtil.isSuccess(updateRelResult)

        // Verify relationship status updated
        GenericValue relationship = from("PartyRelationship").where([
            partyIdFrom: partyId1,
            partyIdTo: partyId2,
            roleTypeIdFrom: "CUSTOMER",
            roleTypeIdTo: "CUSTOMER",
            fromDate: fromDate
        ]).queryOne()
        assert relationship != null
        assert relationship.statusId == "PARTYREL_EXPIRED"
    }
}
