(define-constant ASTERIA 'SP343J7DNE122AVCSC4HEK4MF871PW470ZSXJ5K66)
(define-constant BRAD 'SPT9JHCME25ZBZM9WCGP7ZN38YA82F77YM5HM08B)
(define-constant ERR-USE-GENERIC-WRAPPER u2511)

(define-constant SNAPSHOT-BLOCK (match (get-block-info? id-header-hash (- block-height u1)) meh meh 0x))
    ;; 0xedbcfc85dd8cec409dd1d79eb02c8609c5722ddaa373d1ef9e1495ae6fad2a36)

(define-data-var snapshot-changes-counter uint u0)

(define-data-var total-committed uint u0)

(define-map committed-per-address principal uint)
(define-map did-wrap-before principal bool)
(define-map mno-snapshot principal uint)

(define-private (get-committed-per-address-internal (address principal))
    (default-to u0 (map-get? committed-per-address address)))


(define-private (exclude (address principal) (amount uint))
    (if
        (or
            (is-eq address BRAD)
            (is-eq address ASTERIA))
        u0
        amount))

(define-private (wrap-mno (amount uint)) 
    (contract-call? .wrapped-nothing-v9 wrap-nthng amount))

(define-private (unwrap-mno (amount uint)) 
    (contract-call? .wrapped-nothing-v9 unwrap amount))

(define-private (genesis-wrap-mno-internal (amount uint) (recipient principal))
    (begin
        (map-set committed-per-address recipient amount)
        (var-set total-committed (+ (var-get total-committed) amount))
        (wrap-mno amount)))

(define-private (genesis-unwrap-mno-internal (amount uint))
    (let (
            (recipient tx-sender)
            (next-total (- (var-get total-committed) amount))
            (committed-amount (get-committed-per-address-internal recipient)))
        (asserts! (> committed-amount u0) (err u800))
        (var-set total-committed next-total)
        (map-set committed-per-address recipient u0)
        (unwrap-mno committed-amount)))


(define-private (get-allowed-mno-amount-internal (address principal))
        (default-to u0 (map-get? mno-snapshot address)))

(define-private (genesis-wrap-wmno-internal (amount uint) (recipient principal))
    (begin
        (asserts! (is-eq u0 (get-committed-per-address-internal tx-sender)) (err u800))
        (try! (contract-call? .wrapped-nothing-v8 unwrap amount))
        (genesis-wrap-mno-internal amount recipient)))

(define-private (genesis-unwrap-wmno-internal (amount uint) (recipient principal))
    (begin
        (asserts! (is-eq amount (get-allowed-wmno-amount tx-sender)) (err u100))
        (try! (genesis-unwrap-mno-internal amount))
        (contract-call? .wrapped-nothing-v8 wrap-nthng amount)))

(define-private (get-allowed-wmno-amount (address principal))
    (exclude address
            (+
                (get-allowed-mno-amount-internal address)
                (at-block SNAPSHOT-BLOCK
                    (unwrap-panic
                        (contract-call? .wrapped-nothing-v8 get-balance address))))))

(define-public (genesis-wrap)
        ;; can only wrap once
        (let (
            (mno-unwrapped (is-none (map-get? did-wrap-before tx-sender)))
        )
            (if 
                (and mno-unwrapped (> (get-allowed-mno-amount-internal tx-sender) u0))
                    (try! (contract-call? .wrapped-nothing-v8 wrap-nthng (get-allowed-mno-amount-internal tx-sender)))
                false)
            (map-set did-wrap-before tx-sender true)
            (genesis-wrap-wmno-internal (get-allowed-wmno-amount tx-sender) tx-sender)))

(define-public (genesis-unwrap-wmno)
        (genesis-unwrap-wmno-internal (get-committed-per-address-internal tx-sender) tx-sender))

;; API
(define-read-only (get-committed-total)
    (ok (var-get total-committed)))

(define-read-only (get-snapshot-block)
    (ok SNAPSHOT-BLOCK))

(define-read-only (get-committed-per-address (address principal))
    (ok (get-committed-per-address-internal address)))

(define-read-only (get-allowed-mno-amount (address principal))
    (ok (get-allowed-mno-amount-internal address)))
