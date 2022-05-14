(define (domain groupd)
    ; determining the requirements fo the domain
    (:requirements :strips :typing :negative-preconditions :durative-actions :numeric-fluents)

    (:types
        ; The types of the objects are distinguished
        crate mover loader - objects
        heavy light fragile - crate
        mover1 mover2 - mover
        loader - loader
    )

    (:predicates
        ; predicates for carrying the different types of crates
        (carry-light ?m - mover ?c - light)
        (carry-fragile ?m1 - mover1 ?m2 - mover2 ?c - fragile)
        (carry-heavy ?m1 ?m2 - mover ?c - heavy)

	; predicates for the state of the mover and loader
        (loader-free ?l - loader)
        (mover-empty ?m - mover)

	; predicates for the position of the mover and crates
        (mover-at-loadingBay ?m - mover)
        (mover-near-crate ?m - mover ?c - crate)
        (crate-at-warehouse ?c - crate)
        (crate-at-loadingBay ?c - crate)
        (crate-at-conveyorBelt ?c - crate)
    )

    (:functions
        ; adding numeric fluents for crates
        (crate_distance ?c - crate)
        (crate_weight ?c - crate)
    )

    (:durative-action move-to-crate-light
        ; moverx goes toward a light crate
        :parameters (?m - mover ?c - light)
        :duration (= ?duration (/ (crate_distance ?c) 10))
        :condition (and (at start (mover-empty ?m))
                        (at start (mover-at-loadingBay ?m))
                        (at start (not (mover-near-crate ?m ?c)))
                        (over all (crate-at-warehouse ?c)))
        :effect (and (at end (not (mover-at-loadingBay ?m)))
                     (at end (mover-near-crate ?m ?c)))
    )


    (:durative-action move-to-crate-heavy
        ; mover1 and mover2 go toward a heavy crate together
        :parameters (?m1 - mover1 ?m2 - mover2 ?c - heavy)
        :duration (= ?duration (/ (crate_distance ?c) 10))
        :condition (and (at start (mover-empty ?m1))
                        (at start (mover-empty ?m2))
                        (at start (mover-at-loadingBay ?m1))
                        (at start (not (mover-near-crate ?m1 ?c)))
                        (at start (mover-at-loadingBay ?m2))
                        (at start (not (mover-near-crate ?m2 ?c)))
                        (over all (crate-at-warehouse ?c)))
        :effect (and (at end (not (mover-at-loadingBay ?m1)))
                     (at end (mover-near-crate ?m1 ?c))
                     (at end (not (mover-at-loadingBay ?m2)))
                     (at end (mover-near-crate ?m2 ?c)))
    )

    (:durative-action move-to-crate-fragile
        ; mover1 and mover2 go toward a fragile crate together
        :parameters (?m1 - mover1 ?m2 - mover2 ?c - fragile)
        :duration (= ?duration (/ (crate_distance ?c) 10))
        :condition (and (at start (mover-empty ?m1))
                        (at start (mover-empty ?m2))
                        (at start (mover-at-loadingBay ?m1))
                        (at start (not (mover-near-crate ?m1 ?c)))
                        (at start (mover-at-loadingBay ?m2))
                        (at start (not (mover-near-crate ?m2 ?c)))
                        (over all (crate-at-warehouse ?c)))
        :effect (and (at end (not (mover-at-loadingBay ?m1)))
                     (at end (mover-near-crate ?m1 ?c))
                     (at end (not (mover-at-loadingBay ?m2)))
                     (at end (mover-near-crate ?m2 ?c)))
    )

    (:durative-action pick-light
        ; moverx picks up a light crate
        :parameters (?m - mover ?c - light)
        :duration (= ?duration 1)
        :condition (and (at start (mover-empty ?m))
                        (over all (mover-near-crate ?m ?c))
                        (at start (crate-at-warehouse ?c)))
        :effect (and (at end (not (mover-empty ?m))) 
                     (at end (not (crate-at-warehouse ?c)))
                     (at end (carry-light ?m ?c)))
    )

    (:durative-action pick-fragile
        ; mover1 and mover2 pick up a fragile crate together
        :parameters (?m1 - mover1 ?m2 - mover2 ?c - fragile)
        :duration (= ?duration 2)
        :condition (and (at start (mover-empty ?m1))
                        (at start (mover-empty ?m2))
                        (over all (mover-near-crate ?m1 ?c))
                        (over all (mover-near-crate ?m2 ?c))
                        (at start (crate-at-warehouse ?c)))
        :effect (and (at end (not (mover-empty ?m1))) 
                     (at end (not (mover-empty ?m2))) 
                     (at end (not (crate-at-warehouse ?c)))
                     (at end (carry-fragile ?m1 ?m2 ?c)))
    )

    (:durative-action pick-heavy
        ; mover1 and mover2 pick up a heavy crate together
        :parameters (?m1 - mover1 ?m2 - mover2 ?c - heavy)
        :duration (= ?duration 1)
        :condition (and (at start (crate-at-warehouse ?c)) 
                        (over all (mover-near-crate ?m1 ?c))
                        (over all (mover-near-crate ?m2 ?c))
                        (at start (mover-empty ?m1))
                        (at start (mover-empty ?m2)))
        :effect (and (at end (not (mover-empty ?m1)))
                     (at end (not (mover-empty ?m2)))
                     (at end (carry-heavy ?m1 ?m2 ?c))
                     (at end (not (crate-at-warehouse ?c))))
    )

    (:durative-action move-to-loadingBay-light
        ; movers to carry a light crate to the loadingBay
        :parameters (?m - mover ?c - light ?l - loader)
        :duration (= ?duration (/ (* (crate_distance ?c)(crate_weight ?c)) 100))
        :condition (and (at start (not (mover-at-loadingBay ?m)))
                        (over all (carry-light ?m ?c))
                        (at end (loader-free ?l)))
        :effect (and (at end  (mover-at-loadingBay ?m)))
    )

    (:durative-action move-to-loadingBay-fragile
        ; mover1 and mover2 carry a fragile crate to the loadingBay together
        :parameters (?m1 - mover1 ?m2 - mover2 ?c - fragile ?l - loader)
        :duration (= ?duration (/ (* (crate_distance ?c)(crate_weight ?c)) 75))
        :condition (and (at start (not (mover-at-loadingBay ?m1)))
                        (at start (not (mover-at-loadingBay ?m2)))
                        (over all (carry-fragile ?m1 ?m2 ?c))
                        (at end (loader-free ?l)))
        :effect (and (at end  (mover-at-loadingBay ?m1))
                     (at end  (mover-at-loadingBay ?m2)))
    )

    (:durative-action move-to-loadingBay-heavy
        ; mover1 and mover2 carry a heavy crate to the loadingBay together
        :parameters (?m1 - mover1 ?m2 - mover2 ?c - heavy ?l - loader)
        :duration (= ?duration (/ (* (crate_distance ?c)(crate_weight ?c)) 100))
        :condition (and (at start (not (mover-at-loadingBay ?m1)))
                        (at start (not (mover-at-loadingBay ?m2)))
                        (over all (carry-heavy ?m1 ?m2 ?c))
                        (at end (loader-free ?l)))
        :effect (and (at end  (mover-at-loadingBay ?m1))
                     (at end  (mover-at-loadingBay ?m2)))
    )

    (:durative-action drop-light
        ; moverx drops a light crate in the loadingBay
        :parameters (?m - mover ?c - light)
        :duration (= ?duration 1)
        :condition (and (at start (carry-light ?m ?c)) 
                        (over all (mover-at-loadingBay ?m)))
        :effect (and (at start (not (carry-light ?m ?c))) 
                        (at end (crate-at-loadingBay ?c))
                        (at end (mover-empty ?m)))
    )

    (:durative-action drop-fragile
        ; mover1 and mover2 drop a fragile crate in the loadingBay together
        :parameters (?m1 - mover1 ?m2 - mover2 ?c - fragile)
        :duration (= ?duration 2)
        :condition (and (at start (carry-fragile ?m1 ?m2 ?c)) 
                        (over all (mover-at-loadingBay ?m1))
                        (over all (mover-at-loadingBay ?m2)))
        :effect (and (at start (not (carry-fragile ?m1 ?m2 ?c))) 
                        (at end (crate-at-loadingBay ?c))
                        (at end (mover-empty ?m1))
                        (at end (mover-empty ?m2)))
    )

    (:durative-action drop-heavy
        ; mover1 and mover2 drop a heavy crate in the loadingBay together
        :parameters (?m1 - mover1 ?m2 - mover2 ?c - heavy)
        :duration (= ?duration 1)
        :condition (and (at start (carry-heavy ?m1 ?m2 ?c))
                        (over all (mover-at-loadingBay ?m1))
                        (over all (mover-at-loadingBay ?m2)))
        :effect (and (at end (not (carry-heavy ?m1 ?m2 ?c)))
                     (at end (crate-at-loadingBay ?c))
                     (at end (mover-empty ?m1))
                     (at end (mover-empty ?m2)))
    )

    (:durative-action load-light
        ; loader loads a crate from loadingBay to the conveyorBelt
        :parameters (?l - loader ?c - light)
        :duration (= ?duration 4)
        :condition (and (at start (crate-at-loadingBay ?c)) 
                        (at start (not (crate-at-conveyorBelt ?c))))
        :effect (and (at end (not (crate-at-loadingBay ?c)))
                     (at end (crate-at-conveyorBelt ?c))
                     (at start (not (loader-free ?l)))
                     (at end (loader-free ?l)))
    )
    
     (:durative-action load-heavy
        ; loader loads a crate from loadingBay to the conveyorBelt
        :parameters (?l - loader ?c - heavy)
        :duration (= ?duration 4)
        :condition (and (at start (crate-at-loadingBay ?c)) 
                        (at start (not (crate-at-conveyorBelt ?c))))
        :effect (and (at end (not (crate-at-loadingBay ?c)))
                     (at end (crate-at-conveyorBelt ?c))
                     (at start (not (loader-free ?l)))
                     (at end (loader-free ?l)))
    )
    (:durative-action load-fragile
        ; loader loads a crate from loadingBay to the conveyorBelt
        :parameters (?l - loader ?c - fragile)
        :duration (= ?duration 6)
        :condition (and (at start (crate-at-loadingBay ?c))
                        (at start (not (crate-at-conveyorBelt ?c))))
        :effect (and (at end (not (crate-at-loadingBay ?c)))
                     (at end (crate-at-conveyorBelt ?c))
                     (at start (not (loader-free ?l)))
                     (at end (loader-free ?l)))
    )    
)

