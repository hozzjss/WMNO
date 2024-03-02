;; Error codes
(define-constant EWW-GREEDY-MF u1001)

;; 88,975,877,083,900
(define-constant ERR-UNAUTHORIZED u1)
(define-constant ERR-YOU-POOR u2)
(define-constant ERR-YOU-FOMOD u3)
(define-constant ERR-INVALID-PARAMS u4)

;; 88,975,877,083,900
(define-constant MAX-SUPPLY u88975877083900)
(impl-trait .sip-010-trait-ft-standard.sip-010-trait)

(define-data-var contract-admin principal tx-sender)

(define-fungible-token wmno9 MAX-SUPPLY)

(define-private (is-safe-to-wrap (amount uint) (wrapper principal)) 
    (let (
            (supply (ft-get-supply wmno9)))
    
        (or 
            (and
                (> supply u80)
                (<= (+ amount supply) MAX-SUPPLY))
            (is-eq contract-caller .genesis-wrapper))))


(define-public (wrap-nthng (amount uint))
    (let
        (
            (current-supply (ft-get-supply wmno9)))
        (asserts! (is-safe-to-wrap amount tx-sender) (err ERR-UNAUTHORIZED))
        (unwrap! (contract-call? .micro-nthng transfer (as-contract tx-sender) amount) (err ERR-YOU-POOR))
        (ft-mint? wmno9 amount tx-sender)))


(define-public (unwrap (amount uint))
    (let (
        (unwrapper tx-sender)
    )
        (asserts! (>= (ft-get-balance wmno9 tx-sender) amount) (err ERR-YOU-POOR))
        (unwrap-panic (ft-burn? wmno9 amount tx-sender))
        (as-contract (contract-call? .micro-nthng transfer unwrapper amount))))

;;;;;;;;;;;;;;;;;;;;; SIP 010 ;;;;;;;;;;;;;;;;;;;;;;

(define-public (transfer (amount uint) (from principal) (to principal) (memo (optional (buff 34))))
    (begin
        (asserts! (is-eq from tx-sender) (err ERR-UNAUTHORIZED))
        (asserts! (not (is-eq to tx-sender)) (err ERR-UNAUTHORIZED))
        (asserts! (>= (ft-get-balance wmno9 from) amount) (err ERR-YOU-POOR))
        (ft-transfer? wmno9 amount from to)))
    


(define-read-only (get-name)
    (ok (var-get token-name)))

(define-read-only (get-symbol)
    (ok (var-get token-symbol)))

(define-read-only (get-decimals)
    (ok (var-get token-decimals)))

(define-read-only (get-balance (user principal))
    (ok (ft-get-balance wmno9 user)))

(define-read-only (get-total-supply)
    (ok (ft-get-supply wmno9)))

(define-read-only (get-token-uri)
    (ok (var-get token-uri)))

;; send-many

(define-public (send-nothing (amount uint) (to principal) (memo (optional (buff 34))))
    (let ((transfer-ok (try! (transfer amount tx-sender to none))))
    (print (default-to 0x memo))
    (ok transfer-ok)))

(define-private (send-nothing-unwrap (recipient { to: principal, amount: uint, memo: (optional (buff 34)) }))
    (send-nothing
        (get amount recipient)
        (get to recipient)
        (get memo recipient)))

(define-private (check-err  (result (response bool uint))
                            (prior (response bool uint)))
    (match prior ok-value result
                err-value (err err-value)))

(define-public (send-many (recipients (list 200 { to: principal, amount: uint, memo: (optional (buff 34)) })))
    (fold check-err
        (map send-nothing-unwrap recipients)
        (ok true)))



;; METADATA
(define-data-var token-uri (optional (string-utf8 256)) (some u"ipfs://ipfs/bafkreiftylv7y3tq4atdtynbe537tgsb7mch6a2g62u3cegjqddle4nyqe"))
(define-data-var token-name (string-ascii 32) "Wrapped Nothing v9")
(define-data-var token-symbol (string-ascii 32) "WMNO9")
(define-data-var token-decimals uint u0)

;; anything can be edited
(define-public 
    (set-metadata 
        (uri (optional (string-utf8 256))) 
        (name (string-ascii 32))
        (symbol (string-ascii 32))
        (decimals uint))
    (begin
        (asserts! (is-eq tx-sender (var-get contract-admin)) (err ERR-UNAUTHORIZED))
        (asserts! 
            (and 
                (is-some uri)
                (> (len name) u0)
                (> (len symbol) u0)
                (<= decimals u6))
            (err ERR-INVALID-PARAMS))
        (var-set token-uri uri)
        (var-set token-name name)
        (var-set token-symbol symbol)
        (var-set token-decimals decimals)
        (ok true)))

;; should be set to a DAO contract in the future
(define-public (set-admin (new-admin principal))
    (begin
        (asserts! (is-eq contract-caller (var-get contract-admin)) (err ERR-UNAUTHORIZED))
        (asserts! (not (is-eq new-admin (var-get contract-admin))) (err ERR-INVALID-PARAMS))
        (var-set contract-admin new-admin)
        (ok true)))
