import org.apache.ofbiz.entity.GenericEntityException;

def createOfbizDemo() {
    result =[:];
    try {
        ofbizDemo= delegator.makeValue("OfbizDemo");

        ofbizDemo.setNextSeqId();

        ofbizDemo.setNonPKFields(context);

        ofbizDemo=delegator.create(ofbizDemo);

        result.ofbizDemoId =ofbizDemo.ofbizDemoId;
        logInfo("========This is my first groovy service in Apache ofbiz , OfbizDemo record" + ofbizDemo.getString("ofbizDemoId"));
    }catch(GenericEntityException e){
        logError(e.getMessage());
        return error("Error in creating record in OfbizDemo entity ......." );
    }
    return result;
}

def logOfbizDemoLastName() {
    logInfo("======== Last Name recorded by SECA: " + context.lastName);
    return success();
}