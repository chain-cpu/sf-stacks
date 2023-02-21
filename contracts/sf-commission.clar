
;; sf-comission
(impl-trait .commission-trait.commission)

(define-constant DEPLOYER tx-sender)
(define-constant ERR-NOT-AUTHORIZED u101)

(define-data-var commission uint u0)
(define-data-var commission-address principal tx-sender)


;; #[allow(unchecked_data)]
(define-public (set-commission-address (address principal))
  (begin
    (asserts! (is-eq tx-sender DEPLOYER) (err ERR-NOT-AUTHORIZED))
    (ok (var-set commission-address address))))

;; #[allow(unchecked_data)]
(define-public (get-commission-address)
  (ok (var-get commission-address))
)

;; #[allow(unchecked_data)]
(define-public (set-commission (comm uint))
  (begin
    (asserts! (is-eq tx-sender DEPLOYER) (err ERR-NOT-AUTHORIZED))
    (ok (var-set commission comm))))

;; #[allow(unchecked_data)]
(define-public (get-commission)
    (ok (var-get commission))
)

(define-public (pay (id uint) (price uint))
  (let (
      (commission-amount (/ (* price (var-get commission)) u10000))
    )
    (if (> commission-amount u0)
      (try! (stx-transfer? commission-amount tx-sender (var-get commission-address)))
      (print false)
    )
    (ok true)
  )
)
