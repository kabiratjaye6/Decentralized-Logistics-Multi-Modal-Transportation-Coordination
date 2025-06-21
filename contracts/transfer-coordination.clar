;; Transfer Coordination Contract
;; Coordinates intermodal transfers between different transportation modes

(define-constant ERR_INVALID_TRANSFER (err u300))
(define-constant ERR_TRANSFER_NOT_FOUND (err u301))
(define-constant ERR_UNAUTHORIZED_COORDINATOR (err u302))
(define-constant ERR_INVALID_STATUS (err u303))

;; Transfer data structure
(define-map transfers
  { transfer-id: uint }
  {
    shipment-id: uint,
    from-mode: uint,
    to-mode: uint,
    transfer-point: (string-ascii 50),
    coordinator: principal,
    status: (string-ascii 20),
    scheduled-time: uint,
    actual-time: (optional uint),
    cost: uint
  }
)

;; Transfer points (hubs)
(define-map transfer-points
  { point-id: uint }
  {
    name: (string-ascii 50),
    location: (string-ascii 50),
    supported-modes: (list 10 uint),
    capacity: uint,
    operational-hours: (string-ascii 20)
  }
)

(define-data-var next-transfer-id uint u1)

;; Initialize transfer points
(map-set transfer-points { point-id: u1 }
  { name: "Central Hub", location: "City Center", supported-modes: (list u1 u2 u3 u4), capacity: u1000, operational-hours: "24/7" })
(map-set transfer-points { point-id: u2 }
  { name: "Port Terminal", location: "Harbor District", supported-modes: (list u1 u3), capacity: u2000, operational-hours: "06:00-22:00" })

;; Schedule a transfer
(define-public (schedule-transfer (shipment-id uint) (from-mode uint) (to-mode uint)
                                 (transfer-point (string-ascii 50)) (scheduled-time uint) (cost uint))
  (let ((transfer-id (var-get next-transfer-id))
        (coordinator tx-sender))
    ;; Verify coordinator is registered (simplified check)
    (asserts! (not (is-eq coordinator 'SP000000000000000000002Q6VF78)) ERR_UNAUTHORIZED_COORDINATOR)

    (map-set transfers
      { transfer-id: transfer-id }
      {
        shipment-id: shipment-id,
        from-mode: from-mode,
        to-mode: to-mode,
        transfer-point: transfer-point,
        coordinator: coordinator,
        status: "scheduled",
        scheduled-time: scheduled-time,
        actual-time: none,
        cost: cost
      }
    )
    (var-set next-transfer-id (+ transfer-id u1))
    (ok transfer-id)
  )
)

;; Update transfer status
(define-public (update-transfer-status (transfer-id uint) (new-status (string-ascii 20)))
  (match (map-get? transfers { transfer-id: transfer-id })
    transfer-data
    (begin
      (asserts! (is-eq tx-sender (get coordinator transfer-data)) ERR_UNAUTHORIZED_COORDINATOR)
      (map-set transfers
        { transfer-id: transfer-id }
        (merge transfer-data { status: new-status })
      )
      (ok true)
    )
    ERR_TRANSFER_NOT_FOUND
  )
)

;; Complete transfer
(define-public (complete-transfer (transfer-id uint))
  (match (map-get? transfers { transfer-id: transfer-id })
    transfer-data
    (begin
      (asserts! (is-eq tx-sender (get coordinator transfer-data)) ERR_UNAUTHORIZED_COORDINATOR)
      (map-set transfers
        { transfer-id: transfer-id }
        (merge transfer-data {
          status: "completed",
          actual-time: (some block-height)
        })
      )
      (ok true)
    )
    ERR_TRANSFER_NOT_FOUND
  )
)

;; Get transfer details
(define-read-only (get-transfer (transfer-id uint))
  (map-get? transfers { transfer-id: transfer-id })
)

;; Get transfers by coordinator
(define-read-only (get-coordinator-transfers (coordinator principal))
  ;; Simplified implementation - in practice would need indexing
  (ok "Use indexing service for coordinator transfers")
)

;; Add transfer point
(define-public (add-transfer-point (point-id uint) (name (string-ascii 50)) (location (string-ascii 50))
                                  (supported-modes (list 10 uint)) (capacity uint) (operational-hours (string-ascii 20)))
  (begin
    (map-set transfer-points
      { point-id: point-id }
      {
        name: name,
        location: location,
        supported-modes: supported-modes,
        capacity: capacity,
        operational-hours: operational-hours
      }
    )
    (ok point-id)
  )
)

;; Get transfer point details
(define-read-only (get-transfer-point (point-id uint))
  (map-get? transfer-points { point-id: point-id })
)
