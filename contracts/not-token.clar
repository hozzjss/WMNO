;; Error codes
(define-constant ERR-YOU-POOR u1001)

;; 88,975,877,083,900
(define-fungible-token NOT u88975877083900)
(define-map claimed-per-address principal uint)

(define-private (get-claimed-per-address-internal (address principal)) 
    (default-to u0 (map-get? claimed-per-address address)))

(define-private (get-claimable (address principal))
    (unwrap-panic (contract-call? .not-lockup get-locked-per-address address)))

(define-public (claim)
    (let
        (
            (total-claimed (get-claimed-per-address-internal tx-sender))
            (claimable (- (get-claimable tx-sender) total-claimed))
            (new-claimed (+ total-claimed claimable))
        )
        (asserts! (> claimable u0) (err ERR-YOU-POOR))
        (map-set claimed-per-address tx-sender new-claimed)
        (ft-mint? NOT claimable tx-sender)
    ))
;; sip 10
(define-read-only (get-balance (address principal))
    (ok (ft-get-balance NOT address)))