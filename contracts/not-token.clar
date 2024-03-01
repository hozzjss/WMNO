;; Error codes
(define-constant EWW-GREEDY-MF u1001)

;; 88,975,877,083,900
(define-fungible-token NOT u88975877083900)
(define-map address-claimed principal bool)

(define-private (get-address-claimed-internal (address principal)) 
    (default-to false (map-get? address-claimed address)))

(define-private (get-claimable (address principal))
    (unwrap-panic (contract-call? .not-lockup get-locked-per-address address)))

(define-public (claim)
    (let
        (
            (claimable (get-claimable tx-sender))
        )
        (asserts! 
            (and 
                (not (get-address-claimed-internal tx-sender)) 
                (> claimable u0)
            )
            (err EWW-GREEDY-MF))
        (map-set address-claimed tx-sender true)
        (ft-mint? NOT claimable tx-sender)
    ))
;; sip 10
(define-read-only (get-balance (address principal))
    (ok (ft-get-balance NOT address)))