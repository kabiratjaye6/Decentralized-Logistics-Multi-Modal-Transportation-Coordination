;; Transportation Coordinator Verification Contract
;; Manages registration and verification of logistics coordinators

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_ALREADY_REGISTERED (err u101))
(define-constant ERR_NOT_FOUND (err u102))
(define-constant ERR_INVALID_STATUS (err u103))

;; Data structures
(define-map coordinators
  { coordinator: principal }
  {
    name: (string-ascii 50),
    license-number: (string-ascii 20),
    status: (string-ascii 10),
    registration-date: uint,
    rating: uint
  }
)

(define-map coordinator-stats
  { coordinator: principal }
  {
    completed-shipments: uint,
    total-value: uint,
    success-rate: uint
  }
)

;; Register a new coordinator
(define-public (register-coordinator (name (string-ascii 50)) (license-number (string-ascii 20)))
  (let ((coordinator tx-sender))
    (asserts! (is-none (map-get? coordinators { coordinator: coordinator })) ERR_ALREADY_REGISTERED)
    (map-set coordinators
      { coordinator: coordinator }
      {
        name: name,
        license-number: license-number,
        status: "pending",
        registration-date: block-height,
        rating: u0
      }
    )
    (map-set coordinator-stats
      { coordinator: coordinator }
      {
        completed-shipments: u0,
        total-value: u0,
        success-rate: u100
      }
    )
    (ok coordinator)
  )
)

;; Verify a coordinator (admin only)
(define-public (verify-coordinator (coordinator principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (match (map-get? coordinators { coordinator: coordinator })
      coordinator-data
      (begin
        (map-set coordinators
          { coordinator: coordinator }
          (merge coordinator-data { status: "verified" })
        )
        (ok true)
      )
      ERR_NOT_FOUND
    )
  )
)

;; Update coordinator rating
(define-public (update-rating (coordinator principal) (new-rating uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (asserts! (<= new-rating u100) ERR_INVALID_STATUS)
    (match (map-get? coordinators { coordinator: coordinator })
      coordinator-data
      (begin
        (map-set coordinators
          { coordinator: coordinator }
          (merge coordinator-data { rating: new-rating })
        )
        (ok true)
      )
      ERR_NOT_FOUND
    )
  )
)

;; Get coordinator info
(define-read-only (get-coordinator (coordinator principal))
  (map-get? coordinators { coordinator: coordinator })
)

;; Check if coordinator is verified
(define-read-only (is-verified (coordinator principal))
  (match (map-get? coordinators { coordinator: coordinator })
    coordinator-data
    (is-eq (get status coordinator-data) "verified")
    false
  )
)
