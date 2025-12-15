# DDR4 Block 1 — PHY Training FSM
## Arise Ember CPU Project

**Status:** Architecture Locked  
**Stage:** Pre-RTL Specification  
**Authoritative Document**

---

## 1. Purpose

Block 1 implements a **DDR4 PHY Training Engine** responsible for discovering, centering, and locking safe timing windows for DDR read operations.

This block operates **independently of the CPU**, cache, or memory controller and is designed to function in a hostile, non-deterministic environment.

The primary goal is **robust convergence**, not boot-time optimization.

---

## 2. Design Philosophy

This block models **real DDR4 training strategy**, not analog physics.

Key principles:

- Window-based correctness, not single-point tuning
- Statistical validation under noise
- Deterministic failure handling
- Retry and recovery built-in
- Extendable to multi-lane, multi-rank systems

The logic must converge reliably across randomized resets and injected drift.

---

## 3. Scope and Constraints

### Included
- Read data eye training
- Full delay sweep
- Window detection and centering
- Delay locking
- Validation
- Retry logic
- Hard failure signaling

### Explicitly Deferred
- Multi-rank support
- Per-byte-lane independence
- Write leveling
- VrefDQ training
- Frequency switching

These are architecturally planned but not implemented in Block 1.

---

## 4. Training Model

### Delay Space
- Delay taps: **64**
- Single adjustable axis: `rd_dqs_delay`
- Delay unit: abstract (simulation-level)

### Sampling Policy
- Samples per delay tap: **N = 8**
- Pass condition: **≥ 7 / 8 successful reads**
- One failure tolerated to model jitter and marginality

### Validation Policy
- Post-lock validation samples: **16**
- Validation pass if failures ≤ threshold (configurable)

---

## 5. External Interface (Logical)

### Inputs
| Signal | Description |
|------|------------|
| `clk` | Training clock |
| `rst_n` | Active-low reset |
| `start_training` | Initiates training |
| `read_ok` | Result of a read attempt |
| `drift_detected` | Optional retraining trigger |

### Outputs
| Signal | Description |
|------|------------|
| `delay_tap` | Current selected delay tap |
| `locked` | Delay configuration locked |
| `training_done` | Training successful |
| `training_fail` | Training failed irrecoverably |
| `retry_count` | Retry attempt counter |

---

## 6. FSM Overview

The Training FSM is a **multi-phase, terminating state machine**.

High-level phases:

1. Idle / Reset
2. Initialization
3. Read Sweep
4. Window Analysis
5. Center Selection
6. Lock
7. Validation
8. Success
9. Failure / Retry

---

## 7. FSM State Definitions

### STATE 0 — IDLE
**Purpose:** Await training request  
**Exit:** `start_training == 1`

---

### STATE 1 — INIT
**Purpose:** Initialize training run  
**Actions:**
- Reset counters
- Clear pass/fail bitmap
- Initialize delay tap (0 or randomized)

**Exit:** Always → READ_SWEEP_SETUP

---

### STATE 2 — READ_SWEEP_SETUP
**Purpose:** Prepare to test current delay tap  
**Actions:**
- Load `delay_tap`
- Reset sample and success counters

**Exit:** Always → READ_SAMPLE

---

### STATE 3 — READ_SAMPLE
**Purpose:** Collect read samples  
**Actions:**
- Perform read
- Increment sample counter
- Increment success counter if `read_ok`

**Exit:**
- If samples < N → stay
- If samples == N → EVALUATE_TAP

---

### STATE 4 — EVALUATE_TAP
**Purpose:** Determine pass/fail for delay tap  
**Actions:**
- PASS if success ≥ N−1
- Record result in bitmap

**Exit:**
- If delay_tap < MAX → increment tap → READ_SWEEP_SETUP
- Else → WINDOW_ANALYSIS

---

### STATE 5 — WINDOW_ANALYSIS
**Purpose:** Detect valid timing windows  
**Actions:**
- Scan bitmap
- Identify contiguous PASS regions
- Record width and boundaries

**Exit:**
- If window found → CENTER_SELECT
- Else → RETRY_DECISION

---

### STATE 6 — CENTER_SELECT
**Purpose:** Choose optimal sampling point  
**Actions:**
- Select widest window
- Compute center index
- Load `delay_tap`

**Exit:** Always → LOCK

---

### STATE 7 — LOCK
**Purpose:** Commit delay configuration  
**Actions:**
- Assert `locked`
- Freeze delay tap

**Exit:** Always → VALIDATION

---

### STATE 8 — VALIDATION
**Purpose:** Verify post-lock stability  
**Actions:**
- Perform validation reads
- Count failures

**Exit:**
- Pass → SUCCESS
- Fail → RETRY_DECISION

---

### STATE 9 — RETRY_DECISION
**Purpose:** Handle non-convergence  
**Actions:**
- Increment retry counter

**Exit:**
- If retries < MAX → INIT
- Else → FAIL

---

### STATE 10 — SUCCESS
**Purpose:** Training completed successfully  
**Actions:**
- Assert `training_done`
- Maintain lock

**Exit:**
- Drift detected → INIT
- Reset → IDLE

---

### STATE 11 — FAIL
**Purpose:** Irrecoverable training failure  
**Actions:**
- Assert `training_fail`
- Deassert `locked`

**Exit:** Reset only

---

## 8. FSM Guarantees

This FSM guarantees:

- Finite termination
- No infinite oscillation
- No false lock
- Deterministic failure reporting
- Restartability after reset

---

## 9. Simulation Requirements

The validation testbench **must** include:

- Random per-run delay skew
- Randomized jitter near window edges
- Occasional read corruption
- Slow timing drift

Passing a single run is insufficient.  
Success is defined as **high convergence rate across many randomized runs**.

---

## 10. Integration Notes

Block 1 is designed as a **standalone IP block**.

It may reside in the Arise Ember CPU Verilog tree without being connected.

Later integration requires no architectural changes.

---

## 11. Extension Path (Future)

This design naturally extends to:

- Per-byte-lane training
- Write leveling
- VrefDQ adjustment
- Multi-rank support
- Runtime retraining policies

These will be additive.

---

**End of Document**
