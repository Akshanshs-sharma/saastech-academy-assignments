package com.companyname.ofbizdemo.services;

import java.util.Map;

import org.apache.ofbiz.base.util.Debug;
import org.apache.ofbiz.entity.Delegator;
import org.apache.ofbiz.entity.GenericEntityException;
import org.apache.ofbiz.entity.GenericValue;
import org.apache.ofbiz.service.DispatchContext;
import org.apache.ofbiz.service.ServiceUtil;

public class OfbizDemoServices {
    public static final String module = OfbizDemoServices.class.getName();

    public static Map<String,Object> createOfbizDemo(DispatchContext dctx, Map<String , ? extends Object> context) {
        Map<String,Object> result = ServiceUtil.returnSuccess();
        Delegator delegator = dctx.getDelegator();
        try{
            GenericValue ofbizDemo = delegator.makeValue("OfbizDemo");

            ofbizDemo.setNextSeqId();

            ofbizDemo.setNonPKFields(context);

            ofbizDemo = delegator.create(ofbizDemo);

            result.put("ofbizDemoId",ofbizDemo.getString("ofbizDemoId"));

            Debug.log("========This is my first Java service Implementation in Apache Ofbiz , OfbizDemo record successfully created" + ofbizDemo.getString("ofbizDemoId"));

        }catch(GenericEntityException e) {
            Debug.logError(e,module);
            return ServiceUtil.returnError("Error in creating reocrd of OfbizDemo entity ......" + module);
        }
        return result;
    }
}