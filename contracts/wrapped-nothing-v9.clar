(define-constant ASTERIA 'SP343J7DNE122AVCSC4HEK4MF871PW470ZSXJ5K66)
(define-constant BRAD 'SPT9JHCME25ZBZM9WCGP7ZN38YA82F77YM5HM08B)
(define-constant HZ tx-sender)


(define-data-var freeze-block (buff 32) 0x304c25f4197ee8454f298442c94130c545b8cd6a8e6795ae3354aae24c416028)
(define-data-var freeze-changes-remaining uint u5)
(use-trait wrapper .wmno-wrap-trait.wrap)

(define-public (update-freeze-block (block (buff 32))) 
    (let (
        (freeze-chances (var-get freeze-changes-remaining))
    ) 
        (asserts! (is-eq tx-sender HZ) (err "you not papa"))
        (asserts! (> freeze-chances u0) (err "too much papa"))
        (var-set freeze-changes-remaining (+ freeze-chances u1))
        (var-set freeze-block block)
        (ok true)))

;; 88,975,877,083,900
(define-fungible-token not-token u88975877083900)

(define-map wrapped5-per-address principal bool)
(define-map wrapped6-per-address principal bool)
(define-map wrapped8-per-address principal bool)
(define-map mno-snapshot principal uint)


(define-private (transfer-mno (to principal) (amount uint)) 
    (contract-call? .micro-nthng transfer to amount))

(define-private (wrap-mno-internal (amount uint) (recipient principal)) 
    (begin 
        (try! (transfer-mno (as-contract tx-sender) amount))
        (ft-mint? not-token amount recipient)))

(define-private (exclude (address principal) (amount uint)) 
    (if 
        (or 
            (is-eq address BRAD)
            (is-eq address ASTERIA))
        u0
        amount))

;; reusables
(define-private (wrap-wmno-internal (contract <wrapper>) (amount uint) (recipient principal)) 
    (begin 
        (try! (contract-call? contract unwrap amount))
        (wrap-mno-internal amount recipient)))

(define-private (unwrap-wmno-internal (contract <wrapper>) (amount uint) (recipient principal)) 
    (begin 
        (try! (as-contract (transfer-mno recipient amount)))
        (try! (contract-call? contract wrap-nthng amount))
        (ft-burn? not-token amount recipient)))

;; WMNO8 handlers
(define-private (get-wrapped8-per-address (address principal))
    (default-to false (map-get? wrapped8-per-address address)))

(define-private (get-allowed-wmno8-amount (address principal))
    (exclude address
            (at-block (var-get freeze-block)
                (unwrap-panic
                    (contract-call? .wrapped-nothing-v8 get-balance address)))))

(define-public (wrap-wmno8)
    (begin
        ;; can only wrap once
        (asserts! (not (get-wrapped8-per-address tx-sender)) (err u800))
        (map-set wrapped8-per-address tx-sender true)
        (wrap-wmno-internal .wrapped-nothing-v8 (get-allowed-wmno8-amount tx-sender) tx-sender)))

(define-public (unwrap-wmno8)
    (begin
        ;; can only wrap once
        (asserts! (get-wrapped8-per-address tx-sender) (err u800))
        (map-set wrapped8-per-address tx-sender false)
        (unwrap-wmno-internal .wrapped-nothing-v8 (get-allowed-wmno8-amount tx-sender) tx-sender)))

;; WMNO6 handlers 
(define-private (get-wrapped6-per-address (address principal))
    (default-to false (map-get? wrapped6-per-address address)))

(define-private (get-allowed-wmno6-amount (address principal))
    (exclude address
            (at-block (var-get freeze-block)
                (unwrap-panic
                    (contract-call? .wrapped-nothing-v6 get-balance-of address)))))

(define-public (wrap-wmno6)
    (begin
        ;; can only wrap once
        (asserts! (not (get-wrapped6-per-address tx-sender)) (err u600))
        (map-set wrapped6-per-address tx-sender true)
        (wrap-wmno-internal .wrapped-nothing-v6 (get-allowed-wmno6-amount tx-sender) tx-sender)))

(define-public (unwrap-wmno6)
    (begin
        ;; can only wrap once
        (asserts! (get-wrapped6-per-address tx-sender) (err u600))
        (map-set wrapped6-per-address tx-sender false)
        (unwrap-wmno-internal .wrapped-nothing-v6 (get-allowed-wmno6-amount tx-sender) tx-sender)))

;; WMNO5 handlers 
(define-private (get-wrapped5-per-address (address principal))
    (default-to false (map-get? wrapped5-per-address address)))

(define-private (get-allowed-wmno5-amount (address principal))
    (exclude address
            (at-block (var-get freeze-block)
                (unwrap-panic
                    (contract-call? .wrapped-nothing-v5 get-balance-of address)))))

(define-public (wrap-wmno5)
    (begin
        ;; can only wrap once
        (asserts! (not (get-wrapped5-per-address tx-sender)) (err u500))
        (map-set wrapped5-per-address tx-sender true)
        (wrap-wmno-internal .wrapped-nothing-v5 (get-allowed-wmno5-amount tx-sender) tx-sender)))

(define-public (unwrap-wmno5)
    (begin
        ;; can only wrap once
        (asserts! (get-wrapped5-per-address tx-sender) (err u500))
        (map-set wrapped5-per-address tx-sender false)
        (unwrap-wmno-internal .wrapped-nothing-v5 (get-allowed-wmno5-amount tx-sender) tx-sender)))
;; MNO handlers 

(define-private (get-allowed-mno-amount (address principal))
    (exclude address
        (default-to u0 (map-get? mno-snapshot address))))

(define-public (wrap-mno)
    (wrap-mno-internal (get-allowed-mno-amount tx-sender) tx-sender))

;; sip 10
(define-read-only (get-balance (address principal))
    (ok (ft-get-balance not-token address)))