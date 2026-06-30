<style>
  .cm-container {
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
    margin: 20px auto;
    max-width: 1200px;
    padding: 0 15px;
  }
  .cm-header {
    margin-bottom: 25px;
    border-bottom: 2px solid #eaeaea;
    padding-bottom: 15px;
  }
  .cm-header h2 {
    color: #2c3e50;
    margin: 0 0 5px 0;
    font-weight: 600;
  }
  .cm-header p {
    color: #7f8c8d;
    margin: 0;
    font-size: 0.95rem;
  }
  .cm-grid {
    display: grid;
    grid-template-columns: 1fr;
    gap: 20px;
    margin-bottom: 30px;
  }
  @media (min-width: 768px) {
    .cm-grid-two-col {
      grid-template-columns: 1fr 1fr;
    }
  }
  .cm-card {
    background: #ffffff;
    border-radius: 8px;
    box-shadow: 0 4px 6px rgba(0,0,0,0.05);
    border: 1px solid #e2e8f0;
    padding: 20px;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
  }
  .cm-card:hover {
    box-shadow: 0 6px 12px rgba(0,0,0,0.08);
  }
  .cm-card-title {
    font-size: 1.15rem;
    font-weight: 600;
    color: #2d3748;
    margin-top: 0;
    margin-bottom: 20px;
    border-bottom: 1px solid #edf2f7;
    padding-bottom: 10px;
  }
  .cm-form-group {
    margin-bottom: 15px;
  }
  .cm-form-group label {
    display: block;
    margin-bottom: 6px;
    font-weight: 500;
    font-size: 0.9rem;
    color: #4a5568;
  }
  .cm-form-control {
    width: 100%;
    padding: 8px 12px;
    border: 1px solid #cbd5e0;
    border-radius: 6px;
    font-size: 0.9rem;
    transition: border-color 0.2s;
    box-sizing: border-box;
  }
  .cm-form-control:focus {
    outline: none;
    border-color: #3182ce;
    box-shadow: 0 0 0 3px rgba(66, 153, 225, 0.15);
  }
  .cm-btn {
    background-color: #3182ce;
    color: white;
    border: none;
    padding: 10px 16px;
    font-size: 0.9rem;
    font-weight: 500;
    border-radius: 6px;
    cursor: pointer;
    transition: background-color 0.2s;
    width: 100%;
  }
  .cm-btn:hover {
    background-color: #2b6cb0;
  }
  .cm-btn-secondary {
    background-color: #48bb78;
  }
  .cm-btn-secondary:hover {
    background-color: #38a169;
  }
  .cm-table-container {
    overflow-x: auto;
    background: #ffffff;
    border-radius: 8px;
    box-shadow: 0 4px 6px rgba(0,0,0,0.05);
    border: 1px solid #e2e8f0;
    margin-bottom: 30px;
  }
  .cm-table {
    width: 100%;
    border-collapse: collapse;
    text-align: left;
    font-size: 0.9rem;
  }
  .cm-table th {
    background-color: #f7fafc;
    color: #4a5568;
    font-weight: 600;
    padding: 12px 16px;
    border-bottom: 2px solid #edf2f7;
  }
  .cm-table td {
    padding: 12px 16px;
    border-bottom: 1px solid #edf2f7;
    color: #2d3748;
  }
  .cm-table tr:hover {
    background-color: #f8fafc;
  }
  .cm-no-results {
    padding: 30px;
    text-align: center;
    color: #718096;
    font-style: italic;
  }
</style>

<div class="cm-container">
  <div class="cm-header">
    <h2>Customer Directory</h2>
    <p>Search, manage records, and establish relationships within the retailer network.</p>
  </div>

  <div class="cm-grid cm-grid-two-col">
    <!-- 1. Search Customer Form -->
    <div class="cm-card">
      <h3 class="cm-card-title">Search Customers</h3>
      <form method="get" action="<@ofbizUrl>main</@ofbizUrl>">
        <div class="cm-form-group">
          <label for="search-email">Email Address</label>
          <input type="text" id="search-email" name="emailAddress" value="${parameters.emailAddress!}" class="cm-form-control" placeholder="e.g. customer@example.com"/>
        </div>
        <div class="cm-form-group">
          <label for="search-firstname">First Name</label>
          <input type="text" id="search-firstname" name="firstName" value="${parameters.firstName!}" class="cm-form-control"/>
        </div>
        <div class="cm-form-group">
          <label for="search-lastname">Last Name</label>
          <input type="text" id="search-lastname" name="lastName" value="${parameters.lastName!}" class="cm-form-control"/>
        </div>
        <div class="cm-form-group">
          <label for="search-phone">Phone Number</label>
          <input type="text" id="search-phone" name="contactNumber" value="${parameters.contactNumber!}" class="cm-form-control"/>
        </div>
        <div class="cm-form-group">
          <label for="search-address">Postal Address (Line 1)</label>
          <input type="text" id="search-address" name="address1" value="${parameters.address1!}" class="cm-form-control"/>
        </div>
        <button type="submit" class="cm-btn">Search Directory</button>
      </form>
    </div>

    <!-- 2. Create Customer Form -->
    <div class="cm-card">
      <h3 class="cm-card-title">Register New Customer</h3>
      <form method="post" action="<@ofbizUrl>createCustomer</@ofbizUrl>">
        <div class="cm-form-group">
          <label for="create-email">Primary Email Address *</label>
          <input type="email" id="create-email" name="emailAddress" required class="cm-form-control" placeholder="unique identifier"/>
        </div>
        <div class="cm-form-group">
          <label for="create-firstname">First Name *</label>
          <input type="text" id="create-firstname" name="firstName" required class="cm-form-control"/>
        </div>
        <div class="cm-form-group">
          <label for="create-lastname">Last Name *</label>
          <input type="text" id="create-lastname" name="lastName" required class="cm-form-control"/>
        </div>
        <button type="submit" class="cm-btn cm-btn-secondary">Create Customer</button>
      </form>
    </div>
  </div>

  <!-- 3. Search Results Table -->
  <div class="cm-card" style="margin-bottom: 30px;">
    <h3 class="cm-card-title">Matches in Directory</h3>
    <div class="cm-table-container">
      <table class="cm-table">
        <thead>
          <tr>
            <th>Party ID</th>
            <th>Email (Primary)</th>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Phone</th>
            <th>Address</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          <#if customerList?has_content>
            <#list customerList as customer>
              <tr>
                <td><strong>${customer.partyId}</strong></td>
                <td>${customer.emailAddress}</td>
                <td>${customer.firstName}</td>
                <td>${customer.lastName}</td>
                <td>${customer.contactNumber!"--"}</td>
                <td>${customer.address1!"--"} <#if customer.city?has_content>, ${customer.city}</#if></td>
                <td>
                  <span class="cm-badge <#if customer.statusId == 'PARTY_ENABLED'>cm-badge-active</#if>">
                    ${customer.statusId!"--"}
                  </span>
                </td>
              </tr>
            </#list>
          <#else>
            <tr>
              <td colspan="7" class="cm-no-results">No customers match the current filters.</td>
            </tr>
          </#if>
        </tbody>
      </table>
    </div>
  </div>

  <div class="cm-grid cm-grid-two-col">
    <!-- 4. Update Customer Form -->
    <div class="cm-card">
      <h3 class="cm-card-title">Update Contact Details</h3>
      <form method="post" action="<@ofbizUrl>updateCustomer</@ofbizUrl>">
        <div class="cm-form-group">
          <label for="update-email">Email Address (Key) *</label>
          <input type="email" id="update-email" name="emailAddress" required class="cm-form-control"/>
        </div>
        <div class="cm-form-group">
          <label for="update-phone">Contact Number</label>
          <input type="text" id="update-phone" name="contactNumber" class="cm-form-control"/>
        </div>
        <div class="cm-form-group">
          <label for="update-address">Postal Address Line 1</label>
          <input type="text" id="update-address" name="address1" class="cm-form-control"/>
        </div>
        <div class="cm-form-group">
          <label for="update-city">City</label>
          <input type="text" id="update-city" name="city" class="cm-form-control"/>
        </div>
        <div class="cm-form-group">
          <label for="update-postal">Postal Code</label>
          <input type="text" id="update-postal" name="postalCode" class="cm-form-control"/>
        </div>
        <button type="submit" class="cm-btn">Update Details</button>
      </form>
    </div>

    <!-- 5. Create Relationship Form -->
    <div class="cm-card">
      <h3 class="cm-card-title">Link Customers (Relationship)</h3>
      <form method="post" action="<@ofbizUrl>createCustomerRelationship</@ofbizUrl>">
        <div class="cm-form-group">
          <label for="rel-from">From Party ID *</label>
          <input type="text" id="rel-from" name="partyIdFrom" required class="cm-form-control"/>
        </div>
        <div class="cm-form-group">
          <label for="rel-to">To Party ID *</label>
          <input type="text" id="rel-to" name="partyIdTo" required class="cm-form-control"/>
        </div>
        <div class="cm-form-group">
          <label for="rel-type">Relationship Type *</label>
          <select id="rel-type" name="partyRelationshipTypeId" class="cm-form-control">
            <option value="GROUP_ROLLUP">Group Rollup</option>
            <option value="EMPLOYMENT">Employment</option>
            <option value="PARTNER">Partner</option>
            <option value="CUSTOMER_REL">Customer Relationship</option>
          </select>
        </div>
        <div class="cm-form-group">
          <label for="role-from">Role From</label>
          <input type="text" id="role-from" name="roleTypeIdFrom" class="cm-form-control" placeholder="default _NA_"/>
        </div>
        <div class="cm-form-group">
          <label for="role-to">Role To</label>
          <input type="text" id="role-to" name="roleTypeIdTo" class="cm-form-control" placeholder="default _NA_"/>
        </div>
        <button type="submit" class="cm-btn cm-btn-secondary">Establish Relationship</button>
      </form>
    </div>
  </div>
</div>
