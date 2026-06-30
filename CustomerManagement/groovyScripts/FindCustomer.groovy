import org.apache.ofbiz.service.ServiceUtil

Map serviceCtx = [:]
if (parameters.emailAddress) serviceCtx.emailAddress = parameters.emailAddress
if (parameters.firstName) serviceCtx.firstName = parameters.firstName
if (parameters.lastName) serviceCtx.lastName = parameters.lastName
if (parameters.contactNumber) serviceCtx.contactNumber = parameters.contactNumber
if (parameters.address1) serviceCtx.address1 = parameters.address1

// Execute findCustomer service
Map findResult = run service: 'findCustomer', with: serviceCtx
context.customerList = findResult.customerList ?: []
