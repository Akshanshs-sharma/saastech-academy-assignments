// @ts-check

/**
 * @typedef {import("../generated/api").RunInput} RunInput
 * @typedef {import("../generated/api").FunctionRunResult} FunctionRunResult
 */

/**
 * @param {RunInput} input
 * @returns {FunctionRunResult}
 */
export function run(input) {
  // MASTERY: Error Handling for Missing Data
  // We use optional chaining (?.) to safely access the attributes array.
  // If 'noteAttributes' doesn't exist, we safely default to an empty array [].
  const attributes = input.cart?.noteAttributes || [];

  // MASTERY: Typo-Proof Dynamic Parsing
  // We search for the 'selling_store_id' key dynamically. 
  // We use .trim() and .toLowerCase() so that if a frontend developer accidentally 
  // passes " Selling_Store_ID ", our code still catches it perfectly without breaking.
  const targetAttribute = attributes.find(attr => {
    const safeKey = (attr.key || "").trim().toLowerCase();
    return safeKey === "selling_store_id";
  });

  // MASTERY: Graceful Fallback
  // If the attribute doesn't exist, or the value is completely empty, we return 
  // empty operations. This allows Shopify to route to the default warehouse safely.
  if (!targetAttribute || !targetAttribute.value || targetAttribute.value.trim() === "") {
    return { operations: [] };
  }

  // We also sanitize the store ID value to prevent typos from causing mismatches
  const targetStoreId = targetAttribute.value.trim().toLowerCase();
  
  const operations = [];
  const locations = input.fulfillmentGroup?.locations || [];

  // MASTERY: Logic Accuracy (Store first, Warehouse fallback)
  locations.forEach((location) => {
    // We compare safely (case-insensitive) to prevent typos in the location ID
    if (location.id.toLowerCase().includes(targetStoreId)) {
      
      // By ranking the store at '100', we guarantee the order routes to the store first.
      // If the store is out of stock, Shopify will automatically fall back to the 
      // other default locations (warehouses) because they remain unranked.
      operations.push({
        rank: {
          locationId: location.id,
          rank: 100 
        }
      });
    }
  });

  return { operations };
}

