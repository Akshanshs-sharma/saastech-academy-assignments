<style>
  @import url('https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap');

  .pm-container {
    font-family: 'Outfit', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
    margin: 30px auto;
    max-width: 1300px;
    padding: 0 20px;
    color: #1e293b;
    background-color: #f8fafc;
  }

  .pm-header {
    background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
    border-radius: 16px;
    padding: 30px 40px;
    color: #ffffff;
    box-shadow: 0 10px 25px rgba(79, 70, 229, 0.15);
    margin-bottom: 35px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    position: relative;
    overflow: hidden;
  }

  .pm-header::after {
    content: '';
    position: absolute;
    top: -50%;
    right: -20%;
    width: 300px;
    height: 300px;
    background: rgba(255, 255, 255, 0.1);
    border-radius: 50%;
    pointer-events: none;
  }

  .pm-header-text h2 {
    font-size: 2.2rem;
    font-weight: 700;
    margin: 0 0 8px 0;
    letter-spacing: -0.02em;
  }

  .pm-header-text p {
    color: #e2e8f0;
    margin: 0;
    font-size: 1.05rem;
    font-weight: 300;
  }

  .pm-stats {
    display: flex;
    gap: 20px;
  }

  .pm-stat-card {
    background: rgba(255, 255, 255, 0.15);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(255, 255, 255, 0.2);
    border-radius: 12px;
    padding: 12px 20px;
    text-align: center;
    min-width: 100px;
  }

  .pm-stat-num {
    font-size: 1.6rem;
    font-weight: 700;
    margin: 0;
  }

  .pm-stat-label {
    font-size: 0.8rem;
    color: #cbd5e1;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    margin: 0;
  }

  .pm-tabs {
    display: flex;
    gap: 10px;
    margin-bottom: 25px;
    border-bottom: 2px solid #e2e8f0;
    padding-bottom: 10px;
  }

  .pm-tab-btn {
    background: none;
    border: none;
    padding: 10px 20px;
    font-size: 1rem;
    font-weight: 500;
    color: #64748b;
    cursor: pointer;
    border-radius: 8px;
    transition: all 0.3s ease;
  }

  .pm-tab-btn.active {
    background-color: #e2e8f0;
    color: #4f46e5;
    font-weight: 600;
  }

  .pm-tab-content {
    display: none;
  }

  .pm-tab-content.active {
    display: block;
  }

  .pm-grid {
    display: grid;
    grid-template-columns: 1fr;
    gap: 25px;
    margin-bottom: 35px;
  }

  @media (min-width: 992px) {
    .pm-grid-3-1 {
      grid-template-columns: 3fr 1fr;
    }
    .pm-grid-2-col {
      grid-template-columns: 1fr 1fr;
    }
  }

  .pm-card {
    background: #ffffff;
    border-radius: 14px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
    border: 1px solid #e2e8f0;
    padding: 28px;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  }

  .pm-card:hover {
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.06);
  }

  .pm-card-title {
    font-size: 1.3rem;
    font-weight: 600;
    color: #0f172a;
    margin-top: 0;
    margin-bottom: 22px;
    border-bottom: 1px solid #f1f5f9;
    padding-bottom: 12px;
    display: flex;
    align-items: center;
    gap: 10px;
  }

  .pm-card-title i {
    color: #4f46e5;
  }

  .pm-form-row {
    display: grid;
    grid-template-columns: 1fr;
    gap: 15px;
    margin-bottom: 15px;
  }

  @media (min-width: 768px) {
    .pm-form-row-2 {
      grid-template-columns: 1fr 1fr;
    }
    .pm-form-row-3 {
      grid-template-columns: 1fr 1fr 1fr;
    }
  }

  .pm-form-group {
    margin-bottom: 18px;
    display: flex;
    flex-direction: column;
  }

  .pm-form-group label {
    margin-bottom: 8px;
    font-weight: 500;
    font-size: 0.92rem;
    color: #475569;
  }

  .pm-form-control {
    padding: 10px 14px;
    border: 1px solid #cbd5e1;
    border-radius: 8px;
    font-size: 0.95rem;
    color: #1e293b;
    transition: all 0.2s ease;
    background-color: #ffffff;
  }

  .pm-form-control:focus {
    outline: none;
    border-color: #6366f1;
    box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.12);
  }

  .pm-btn {
    background: linear-gradient(135deg, #4f46e5 0%, #6366f1 100%);
    color: #ffffff;
    border: none;
    padding: 12px 20px;
    font-size: 0.95rem;
    font-weight: 600;
    border-radius: 8px;
    cursor: pointer;
    transition: all 0.2s ease;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    box-shadow: 0 4px 10px rgba(79, 70, 229, 0.12);
  }

  .pm-btn:hover {
    transform: translateY(-1px);
    box-shadow: 0 6px 14px rgba(79, 70, 229, 0.2);
    filter: brightness(1.05);
  }

  .pm-btn-secondary {
    background: linear-gradient(135deg, #0d9488 0%, #14b8a6 100%);
    box-shadow: 0 4px 10px rgba(13, 148, 136, 0.12);
  }

  .pm-btn-secondary:hover {
    box-shadow: 0 6px 14px rgba(13, 148, 136, 0.2);
  }

  .pm-btn-danger {
    background: linear-gradient(135deg, #e11d48 0%, #f43f5e 100%);
    box-shadow: 0 4px 10px rgba(225, 29, 72, 0.12);
  }

  .pm-btn-danger:hover {
    box-shadow: 0 6px 14px rgba(225, 29, 72, 0.2);
  }

  .pm-table-container {
    overflow-x: auto;
    border-radius: 10px;
    border: 1px solid #e2e8f0;
  }

  .pm-table {
    width: 100%;
    border-collapse: collapse;
    text-align: left;
    font-size: 0.95rem;
  }

  .pm-table th {
    background-color: #f8fafc;
    color: #475569;
    font-weight: 600;
    padding: 14px 18px;
    border-bottom: 2px solid #edf2f7;
    white-space: nowrap;
  }

  .pm-table td {
    padding: 14px 18px;
    border-bottom: 1px solid #f1f5f9;
    color: #334155;
    vertical-align: middle;
  }

  .pm-table tr:hover {
    background-color: #f1f5f9;
  }

  .pm-badge-list {
    display: flex;
    flex-wrap: wrap;
    gap: 6px;
  }

  .pm-badge {
    display: inline-block;
    padding: 3px 10px;
    font-size: 0.78rem;
    font-weight: 600;
    border-radius: 12px;
    text-transform: capitalize;
  }

  .pm-badge-cat {
    background-color: #e0f2fe;
    color: #0369a1;
  }

  .pm-badge-feat {
    background-color: #f3e8ff;
    color: #6b21a8;
  }

  .pm-price {
    font-weight: 600;
    color: #0f172a;
  }

  .pm-no-results {
    padding: 40px;
    text-align: center;
    color: #64748b;
    font-style: italic;
  }

  .pm-pagination {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 20px;
    padding: 10px;
    background-color: #f8fafc;
    border-radius: 8px;
    border: 1px solid #e2e8f0;
  }

  .pm-page-info {
    font-size: 0.9rem;
    color: #64748b;
  }

  .pm-page-controls {
    display: flex;
    gap: 8px;
  }

  .pm-page-btn {
    background: #ffffff;
    border: 1px solid #cbd5e1;
    padding: 6px 12px;
    font-size: 0.88rem;
    font-weight: 500;
    border-radius: 6px;
    cursor: pointer;
    transition: all 0.2s ease;
    color: #475569;
  }

  .pm-page-btn:hover:not(:disabled) {
    background-color: #f1f5f9;
    border-color: #94a3b8;
  }

  .pm-page-btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }

  .pm-action-link {
    color: #4f46e5;
    text-decoration: none;
    font-weight: 600;
    cursor: pointer;
  }

  .pm-action-link:hover {
    text-decoration: underline;
  }
</style>

<div class="pm-container">
  <!-- 1. Header with Stats -->
  <div class="pm-header">
    <div class="pm-header-text">
      <h2>Retailer Product Finder</h2>
      <p>Manage product definitions, pricing, category memberships, and virtual-variant relationships.</p>
    </div>
    <div class="pm-stats">
      <div class="pm-stat-card">
        <p class="pm-stat-num">${productList?size}</p>
        <p class="pm-stat-label">Matches</p>
      </div>
      <div class="pm-stat-card">
        <p class="pm-stat-num">${categoriesList?size}</p>
        <p class="pm-stat-label">Categories</p>
      </div>
      <div class="pm-stat-card">
        <p class="pm-stat-num">${featuresList?size}</p>
        <p class="pm-stat-label">Features</p>
      </div>
    </div>
  </div>

  <!-- 2. Tabs to toggle between Finder, Register, Update, and Variant Management -->
  <div class="pm-tabs">
    <button class="pm-tab-btn active" onclick="switchTab('tab-finder')">Product Finder</button>
    <button class="pm-tab-btn" onclick="switchTab('tab-register')">Register Product</button>
    <button class="pm-tab-btn" onclick="switchTab('tab-update')">Update Price & Features</button>
    <button class="pm-tab-btn" onclick="switchTab('tab-variant')">Virtual & Variant Setup</button>
  </div>

  <!-- TAB 1: PRODUCT FINDER (Search & Results) -->
  <div id="tab-finder" class="pm-tab-content active">
    <div class="pm-grid pm-grid-3-1">
      <!-- Search Form -->
      <div class="pm-card">
        <h3 class="pm-card-title">Search Filters</h3>
        <form method="get" action="<@ofbizUrl>main</@ofbizUrl>">
          <div class="pm-form-row pm-form-row-3">
            <div class="pm-form-group">
              <label for="search-id">Product ID</label>
              <input type="text" id="search-id" name="productId" value="${parameters.productId!}" class="pm-form-control" placeholder="e.g. 10000"/>
            </div>
            <div class="pm-form-group">
              <label for="search-name">Product Name</label>
              <input type="text" id="search-name" name="productName" value="${parameters.productName!}" class="pm-form-control" placeholder="e.g. T-Shirt"/>
            </div>
            <div class="pm-form-group">
              <label for="search-category">Category</label>
              <select id="search-category" name="productCategoryId" class="pm-form-control">
                <option value="">-- All Categories --</option>
                <#list categoriesList as category>
                  <option value="${category.productCategoryId}" <#if (parameters.productCategoryId!) == category.productCategoryId>selected</#if>>${category.description!category.productCategoryId}</option>
                </#list>
              </select>
            </div>
          </div>

          <div class="pm-form-row pm-form-row-3">
            <div class="pm-form-group">
              <label for="search-min-price">Min Price (USD)</label>
              <input type="number" step="0.01" id="search-min-price" name="minPrice" value="${parameters.minPrice!}" class="pm-form-control"/>
            </div>
            <div class="pm-form-group">
              <label for="search-max-price">Max Price (USD)</label>
              <input type="number" step="0.01" id="search-max-price" name="maxPrice" value="${parameters.maxPrice!}" class="pm-form-control"/>
            </div>
            <div class="pm-form-group">
              <label for="search-feature">Feature</label>
              <select id="search-feature" name="productFeatureId" class="pm-form-control">
                <option value="">-- All Features --</option>
                <#list featuresList as feature>
                  <option value="${feature.productFeatureId}" <#if (parameters.productFeatureId!) == feature.productFeatureId>selected</#if>>${feature.description!feature.productFeatureId} (${feature.productFeatureTypeId})</option>
                </#list>
              </select>
            </div>
          </div>

          <div style="display: flex; gap: 15px; justify-content: flex-end;">
            <a href="<@ofbizUrl>main</@ofbizUrl>" class="pm-btn pm-btn-danger" style="text-decoration: none;">Clear</a>
            <button type="submit" class="pm-btn">Apply Search</button>
          </div>
        </form>
      </div>

      <!-- Quick Actions Info -->
      <div class="pm-card" style="background-color: #f1f5f9;">
        <h4 style="margin-top:0; color:#0f172a;">Search Tips</h4>
        <p style="font-size:0.88rem; line-height:1.5; color:#475569;">
          * Searches are case-insensitive and support partial matching on product names and IDs.<br/><br/>
          * You can filter by price ranges or features (e.g. Red, XL, etc.) dynamically.
        </p>
      </div>
    </div>

    <!-- Results Card -->
    <div class="pm-card">
      <h3 class="pm-card-title">Product Directory Results</h3>
      <div class="pm-table-container">
        <table class="pm-table" id="results-table">
          <thead>
            <tr>
              <th>Product ID</th>
              <th>Product Name</th>
              <th>Categories</th>
              <th>List Price</th>
              <th>Applied Features</th>
              <th style="text-align: right;">Action</th>
            </tr>
          </thead>
          <tbody id="results-body">
            <#if productList?has_content>
              <#list productList as product>
                <tr class="product-row">
                  <td><strong>${product.productId}</strong></td>
                  <td>${product.productName!product.internalName}</td>
                  <td>
                    <div class="pm-badge-list">
                      <#if product.categories?has_content>
                        <#list product.categories as cat>
                          <span class="pm-badge pm-badge-cat">${cat}</span>
                        </#list>
                      <#else>
                        <span style="color:#94a3b8; font-size:0.85rem;">None</span>
                      </#if>
                    </div>
                  </td>
                  <td class="pm-price">
                    <#if product.price?has_content>
                      $${product.price?string(",##0.00")}
                    <#else>
                      <span style="color:#94a3b8; font-size:0.85rem;">No Price</span>
                    </#if>
                  </td>
                  <td>
                    <div class="pm-badge-list">
                      <#if product.features?has_content>
                        <#list product.features as feat>
                          <span class="pm-badge pm-badge-feat">${feat}</span>
                        </#list>
                      <#else>
                        <span style="color:#94a3b8; font-size:0.85rem;">None</span>
                      </#if>
                    </div>
                  </td>
                  <td style="text-align: right;">
                    <a class="pm-action-link" onclick="quickEdit('${product.productId}', '${product.price!}')">Edit Details</a>
                  </td>
                </tr>
              </#list>
            <#else>
              <tr>
                <td colspan="6" class="pm-no-results">No products matched the current filters.</td>
              </tr>
            </#if>
          </tbody>
        </table>
      </div>

      <!-- Pagination Footer -->
      <#if productList?has_content>
        <div class="pm-pagination">
          <div class="pm-page-info" id="page-info">
            Showing 1-10 of ${productList?size} products
          </div>
          <div class="pm-page-controls">
            <button class="pm-page-btn" id="btn-prev" onclick="prevPage()" disabled>Previous</button>
            <button class="pm-page-btn" id="btn-next" onclick="nextPage()">Next</button>
          </div>
        </div>
      </#if>
    </div>
  </div>

  <!-- TAB 2: REGISTER PRODUCT -->
  <div id="tab-register" class="pm-tab-content">
    <div class="pm-card" style="max-width: 600px; margin: 0 auto;">
      <h3 class="pm-card-title">Register New Product</h3>
      <form method="post" action="<@ofbizUrl>createProduct</@ofbizUrl>">
        <div class="pm-form-group">
          <label for="create-name">Product Name *</label>
          <input type="text" id="create-name" name="productName" required class="pm-form-control" placeholder="e.g. Premium Cotton Socks"/>
        </div>
        <div class="pm-form-group">
          <label for="create-category">Product Category *</label>
          <select id="create-category" name="productCategoryId" required class="pm-form-control">
            <option value="">-- Select Category --</option>
            <#list categoriesList as category>
              <option value="${category.productCategoryId}">${category.description!category.productCategoryId}</option>
            </#list>
          </select>
        </div>
        <div class="pm-form-group">
          <label for="create-price">List Price (USD) *</label>
          <input type="number" step="0.01" id="create-price" name="price" required class="pm-form-control" placeholder="e.g. 19.99"/>
        </div>
        <button type="submit" class="pm-btn pm-btn-secondary" style="width: 100%; margin-top: 10px;">Create Product</button>
      </form>
    </div>
  </div>

  <!-- TAB 3: UPDATE PRICE & FEATURES -->
  <div id="tab-update" class="pm-tab-content">
    <div class="pm-card" style="max-width: 600px; margin: 0 auto;">
      <h3 class="pm-card-title">Update Price & Applied Features</h3>
      <form method="post" action="<@ofbizUrl>updateProduct</@ofbizUrl>">
        <div class="pm-form-group">
          <label for="update-id">Product ID *</label>
          <input type="text" id="update-id" name="productId" required class="pm-form-control" placeholder="e.g. 10010"/>
        </div>
        <div class="pm-form-group">
          <label for="update-price">Update List Price (USD)</label>
          <input type="number" step="0.01" id="update-price" name="price" class="pm-form-control" placeholder="Keep empty to leave unchanged"/>
        </div>
        <div class="pm-form-group">
          <label for="update-feature">Apply New Feature</label>
          <select id="update-feature" name="productFeatureId" class="pm-form-control">
            <option value="">-- No changes or select feature --</option>
            <#list featuresList as feature>
              <option value="${feature.productFeatureId}">${feature.description!feature.productFeatureId} (${feature.productFeatureTypeId})</option>
            </#list>
          </select>
        </div>
        <button type="submit" class="pm-btn" style="width: 100%; margin-top: 10px;">Apply Updates</button>
      </form>
    </div>
  </div>

  <!-- TAB 4: VIRTUAL & VARIANT SETUP -->
  <div id="tab-variant" class="pm-tab-content">
    <div class="pm-grid pm-grid-2-col">
      <!-- 1. Associate Variant to Virtual -->
      <div class="pm-card">
        <h3 class="pm-card-title">Link Variant to Virtual Product</h3>
        <form method="post" action="<@ofbizUrl>assocProductToVirtual</@ofbizUrl>">
          <div class="pm-form-group">
            <label for="assoc-virtual-id">Virtual Product ID *</label>
            <input type="text" id="assoc-virtual-id" name="virtualProductId" required class="pm-form-control" placeholder="e.g. V_SHIRT"/>
          </div>
          <div class="pm-form-group">
            <label for="assoc-variant-id">Variant Product ID *</label>
            <input type="text" id="assoc-variant-id" name="productId" required class="pm-form-control" placeholder="e.g. V_SHIRT_RED_M"/>
          </div>
          <button type="submit" class="pm-btn pm-btn-secondary" style="width: 100%; margin-top: 10px;">Link Relationship</button>
        </form>
      </div>

      <!-- 2. Modify Relationship -->
      <div class="pm-card">
        <h3 class="pm-card-title">Modify Variant Relationship</h3>
        <form method="post" action="<@ofbizUrl>updateProductVariant</@ofbizUrl>">
          <div class="pm-form-group">
            <label for="mod-virtual-id">Virtual Product ID *</label>
            <input type="text" id="mod-virtual-id" name="virtualProductId" required class="pm-form-control"/>
          </div>
          <div class="pm-form-group">
            <label for="mod-variant-id">Variant Product ID *</label>
            <input type="text" id="mod-variant-id" name="productId" required class="pm-form-control"/>
          </div>
          <div class="pm-form-row pm-form-row-2">
            <div class="pm-form-group">
              <label for="mod-seq">Sequence Number</label>
              <input type="number" id="mod-seq" name="sequenceNum" class="pm-form-control"/>
            </div>
            <div class="pm-form-group">
              <label for="mod-qty">Quantity</label>
              <input type="number" step="0.000001" id="mod-qty" name="quantity" class="pm-form-control"/>
            </div>
          </div>
          <div class="pm-form-group">
            <label for="mod-thru">Thru Date</label>
            <input type="datetime-local" id="mod-thru" name="thruDate" class="pm-form-control"/>
          </div>
          <button type="submit" class="pm-btn" style="width: 100%; margin-top: 10px;">Update Relationship</button>
        </form>
      </div>
    </div>
  </div>
</div>

<script>
  // Tab switching logic
  function switchTab(tabId) {
    const tabs = document.querySelectorAll('.pm-tab-content');
    const buttons = document.querySelectorAll('.pm-tab-btn');

    tabs.forEach(tab => {
      tab.classList.remove('active');
    });
    buttons.forEach(btn => {
      btn.classList.remove('active');
    });

    document.getElementById(tabId).classList.add('active');
    event.currentTarget.classList.add('active');
  }

  // Pre-fill Update Form when clicking "Edit Details"
  function quickEdit(productId, currentPrice) {
    switchTab('tab-update');
    document.getElementById('update-id').value = productId;
    if (currentPrice) {
      document.getElementById('update-price').value = currentPrice;
    } else {
      document.getElementById('update-price').value = '';
    }
  }

  // Client-side pagination logic
  const itemsPerPage = 10;
  let currentPage = 1;
  const rows = Array.from(document.querySelectorAll('.product-row'));
  const totalItems = rows.length;
  const totalPages = Math.ceil(totalItems / itemsPerPage);

  function showPage(page) {
    if (page < 1) page = 1;
    if (page > totalPages) page = totalPages;
    currentPage = page;

    const startIdx = (currentPage - 1) * itemsPerPage;
    const endIdx = startIdx + itemsPerPage;

    rows.forEach((row, idx) => {
      if (idx >= startIdx && idx < endIdx) {
        row.style.display = '';
      } else {
        row.style.display = 'none';
      }
    });

    const infoElem = document.getElementById('page-info');
    if (infoElem) {
      if (totalItems === 0) {
        infoElem.textContent = 'No products to display';
      } else {
        const displayEnd = Math.min(endIdx, totalItems);
        infoElem.textContent = 'Showing ' + (startIdx + 1) + '-' + displayEnd + ' of ' + totalItems + ' products';
      }
    }

    const btnPrev = document.getElementById('btn-prev');
    const btnNext = document.getElementById('btn-next');
    if (btnPrev) btnPrev.disabled = (currentPage === 1);
    if (btnNext) btnNext.disabled = (currentPage === totalPages || totalPages === 0);
  }

  function prevPage() {
    showPage(currentPage - 1);
  }

  function nextPage() {
    showPage(currentPage + 1);
  }

  // Initialize first page
  if (totalItems > 0) {
    showPage(1);
  }
</script>
