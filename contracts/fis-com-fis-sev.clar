
;; one week until free for all
(define-constant FREE-FOR-ALL-HEIGHT (+ block-height (* u7 u144)))
;; only 1450 may claim
(contract-call? .wrapped-nothing-v8 transfer u20600066000050 tx-sender (as-contract tx-sender) none)

(define-map claimers principal bool)

(define-private (trans (address principal))
    (as-contract (contract-call? .wrapped-nothing-v8 transfer u14206942069 tx-sender address none)))

(define-private (add-claim (claimer principal)) 
    (map-insert claimers claimer true))

(define-public (claim) 
    (let
        (
            (is-free-for-all (> block-height FREE-FOR-ALL-HEIGHT))
            (is-claim-valid  (default-to false (map-get? claimers contract-caller)))
        )
        (asserts! (or is-claim-valid is-free-for-all) (err "greedy ew"))
        ;; Stacks australiar furgive meer
        (asserts! (is-ok (trans contract-caller)) (err "aur naur nur mur quids"))
        (map-set claimers contract-caller false)
        (ok true)))
