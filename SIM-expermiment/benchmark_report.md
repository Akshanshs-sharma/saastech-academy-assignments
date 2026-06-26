# Benchmark Report: Moqui Entity Engine MySQL Streaming Validation

**Date:** June 26, 2026  
**Objective:** Empirically validate whether Moqui's `EntityListIterator` correcty streams large MySQL datasets row-by-row under default connection settings, or if it triggers result set buffering.

---

## 1. Executive Summary
The team's belief was that `ec.entity.find(...).iterator()` natively streams rows from MySQL to keep heap memory flat and bounded. 

**This belief is FALSE.** 
Under default connection configurations (without `useCursorFetch=true`), Moqui's Entity Engine buffers the entire result set in the JVM heap memory immediately when the iterator is created. The iterator is only lazy at the API level, while the underlying JDBC driver buffers the entire payload in memory.

---

## 2. Hypothesis vs. Alternative

* **Hypothesis (H):** *When reading from a MySQL source with the default connection configuration, Moqui's EntityListIterator (`.iterator()`) streams rows row-by-row and keeps JVM heap usage flat and bounded — independent of how many rows the query matches.*
* **Alternative (A):** *MySQL's Connector/J driver ignores positive fetch sizes (like Moqui's default of 100) and buffers the entire result set into JVM memory before the first row is read. Therefore, heap grows with row count, and the iterator is lazy only on the surface.*

### **Conclusion: Hypothesis (H) is REFUTED. Alternative (A) is CONFIRMED.**

---

## 3. Experimental Setup
* **Dataset Size:** 1,048,576 rows (in `test_large_entity`).
* **JVM Heap Limit:** 256 MB (`-Xmx256m`).
* **Framework:** Moqui Framework 3.x.
* **Database:** MySQL 8.x.

---

## 4. Benchmark Results

We measured the execution times and JVM heap memory usage under both configurations (with and without cursor fetch) using Moqui's Entity Engine and a Raw JDBC control.

| Scenario | Execution/Buffer Time | Row Drain Time | Baseline Memory | Post-Query Memory | Net Memory Delta | Streaming? |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **1. Moqui (`useCursorFetch=false`)** | 1,128 ms | 1,627 ms | 64 MB | 216 MB | **152 MB** | **NO** (Buffered) |
| **2. Moqui (`useCursorFetch=true`)** | 1,336 ms | 3,221 ms | 48 MB | 48 MB | **0 MB** | **YES** (via Cursors) |
| **3. Raw JDBC (`useCursorFetch=false` + `MIN_VALUE`)** | **26 ms** | **1,057 ms** | 54 MB | 54 MB | **0 MB** | **YES** (Native Stream) |
| **4. Raw JDBC (`useCursorFetch=true` + `MIN_VALUE`)** | 35 ms | 1,329 ms | 53 MB | 54 MB | **1 MB** | **YES** (Native Stream) |

---

## 5. Key Findings & Analysis

### A. The Smoking Gun: 152 MB Buffering Delta
In **Scenario 1** (Moqui default), the memory before reading the first row spiked instantly by **152 MB** (jumping from 64 MB to 216 MB). This proves the driver immediately downloaded the entire table into memory upon query execution.

### B. The Cursor Fetch Trade-Off
When we enabled `useCursorFetch=true` (**Scenario 2**), Moqui successfully streamed the data, keeping memory flat (0 MB delta). However, it took **twice as long to drain** (3,221 ms vs 1,627 ms) because of the network round-trip overhead of fetching rows in batches of 100.

### C. The Bypassed Block (Positive Control)
In **Scenario 3**, we used Raw JDBC and set the fetch size to `Integer.MIN_VALUE`. The driver streamed row-by-row without server-side cursors, achieving **0 MB memory delta** and draining the table in just **1,057 ms** (3x faster than Moqui streaming). 

Moqui's Entity Engine is blocked from using this optimal mode because its internal builder (`EntityFindBuilder.java`) overrides negative fetch sizes and coerces them to `100`.

---

## 6. Recommendations for Sync Engine
For the MySQL $\rightarrow$ H2 sync engine, the team should **bypass Moqui's Entity Engine and read using raw JDBC with a fetch size of `Integer.MIN_VALUE`**. 

This approach provides:
1. **Absolute Memory Safety:** 0 MB buffering overhead, removing any OutOfMemory risks on huge tables.
2. **Maximum Performance:** 3x faster than Moqui's streaming configuration.
3. **No Database Configuration Overhead:** Works out-of-the-box without requiring `useCursorFetch=true` on the MySQL connection.
