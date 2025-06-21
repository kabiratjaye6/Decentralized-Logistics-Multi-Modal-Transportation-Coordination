;; Cost Optimization Contract
;; Optimizes transportation costs across different routes and modes

(define-constant ERR_INVALID_ROUTE (err u500))
(define-constant ERR_NO_OPTIMIZATION_FOUND (err u501))
(define-constant ERR_INVALID_PARAMETERS (err u502))

;; Cost factors
(define-map cost-factors
  { factor-id: uint }
  {
    name: (string-ascii 30),
    base-cost: uint,
    variable-cost-per-unit: uint,
    multiplier: uint
  }
)

;; Route costs
(define-map route-costs
  { route-id: uint, mode-id: uint }
  {
    base-cost: uint,
    cost-per-km: uint,
    cost-per-kg: uint,
    fuel-surcharge: uint,
    handling-fee: uint
  }
)

;; Optimization results
(define-map optimization-results
  { optimization-id: uint }
  {
    requester: principal,
    origin: (string-ascii 30),
    destination: (string-ascii 30),
    weight-kg: uint,
    optimal-route: (list 5 uint),
    optimal-modes: (list 5 uint),
    total-cost: uint,
    estimated-time: uint,
    created-at: uint
  }
)

(define-data-var next-optimization-id uint u1)

;; Initialize cost factors
(map-set cost-factors { factor-id: u1 }
  { name: "fuel", base-cost: u100, variable-cost-per-unit: u2, multiplier: u100 })
(map-set cost-factors { factor-id: u2 }
  { name: "labor", base-cost: u200, variable-cost-per-unit: u5, multiplier: u100 })
(map-set cost-factors { factor-id: u3 }
  { name: "insurance", base-cost: u50, variable-cost-per-unit: u1, multiplier: u100 })

;; Initialize route costs
(map-set route-costs { route-id: u1, mode-id: u1 } ;; Truck
  { base-cost: u500, cost-per-km: u50, cost-per-kg: u2, fuel-surcharge: u10, handling-fee: u100 })
(map-set route-costs { route-id: u1, mode-id: u2 } ;; Rail
  { base-cost: u800, cost-per-km: u30, cost-per-kg: u1, fuel-surcharge: u5, handling-fee: u200 })

;; Calculate route cost
(define-public (calculate-route-cost (route-id uint) (mode-id uint) (distance-km uint) (weight-kg uint))
  (match (map-get? route-costs { route-id: route-id, mode-id: mode-id })
    cost-data
    (let ((base (get base-cost cost-data))
          (per-km (get cost-per-km cost-data))
          (per-kg (get cost-per-kg cost-data))
          (surcharge (get fuel-surcharge cost-data))
          (handling (get handling-fee cost-data)))
      (ok (+ base
             (* per-km distance-km)
             (* per-kg weight-kg)
             surcharge
             handling))
    )
    ERR_INVALID_ROUTE
  )
)

;; Optimize route and mode selection
(define-public (optimize-transportation (origin (string-ascii 30)) (destination (string-ascii 30))
                                       (weight-kg uint) (available-routes (list 5 uint))
                                       (available-modes (list 5 uint)))
  (let ((optimization-id (var-get next-optimization-id))
        (best-combination (find-optimal-combination available-routes available-modes weight-kg)))

    (asserts! (> weight-kg u0) ERR_INVALID_PARAMETERS)

    (map-set optimization-results
      { optimization-id: optimization-id }
      {
        requester: tx-sender,
        origin: origin,
        destination: destination,
        weight-kg: weight-kg,
        optimal-route: (get routes best-combination),
        optimal-modes: (get modes best-combination),
        total-cost: (get cost best-combination),
        estimated-time: (get time best-combination),
        created-at: block-height
      }
    )

    (var-set next-optimization-id (+ optimization-id u1))
    (ok optimization-id)
  )
)

;; Helper function to find optimal combination
(define-private (find-optimal-combination (routes (list 5 uint)) (modes (list 5 uint)) (weight uint))
  ;; Simplified optimization - in practice would use more complex algorithms
  {
    routes: routes,
    modes: modes,
    cost: u1000, ;; Placeholder calculation
    time: u48     ;; Placeholder time in hours
  }
)

;; Update cost factors
(define-public (update-cost-factor (factor-id uint) (base-cost uint) (variable-cost uint) (multiplier uint))
  (begin
    (map-set cost-factors
      { factor-id: factor-id }
      {
        name: (default-to "unknown" (get name (map-get? cost-factors { factor-id: factor-id }))),
        base-cost: base-cost,
        variable-cost-per-unit: variable-cost,
        multiplier: multiplier
      }
    )
    (ok true)
  )
)

;; Get optimization result
(define-read-only (get-optimization-result (optimization-id uint))
  (map-get? optimization-results { optimization-id: optimization-id })
)

;; Calculate total cost for multi-modal journey
(define-public (calculate-multimodal-cost (route-modes (list 5 { route-id: uint, mode-id: uint, distance: uint })) (weight-kg uint))
  (ok (fold calculate-segment-cost route-modes { total: u0, weight: weight-kg }))
)

;; Helper function for segment cost calculation
(define-private (calculate-segment-cost (segment { route-id: uint, mode-id: uint, distance: uint })
                                       (acc { total: uint, weight: uint }))
  (match (map-get? route-costs { route-id: (get route-id segment), mode-id: (get mode-id segment) })
    cost-data
    (let ((segment-cost (+ (get base-cost cost-data)
                          (* (get cost-per-km cost-data) (get distance segment))
                          (* (get cost-per-kg cost-data) (get weight acc))
                          (get fuel-surcharge cost-data)
                          (get handling-fee cost-data))))
      { total: (+ (get total acc) segment-cost), weight: (get weight acc) })
    acc
  )
)

;; Get cost factor
(define-read-only (get-cost-factor (factor-id uint))
  (map-get? cost-factors { factor-id: factor-id })
)
