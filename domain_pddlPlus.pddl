(define (domain groupd)
    ; determining the requirements fo the domain
    (:requirements :strips :typing :negative-preconditions :conditional-effects :fluents) 

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
        (carry-light-double ?m1 - mover1 ?m2 - mover2 ?c - light)
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

    (:process move-to-crate-light
        ; moverx goes toward a light crate
        :parameters (?m - mover ?c - light)
        :precondition (and (mover-empty ?m)
                        (= #t (/ (crate_distance ?c) 10))
                        (mover-at-loadingBay ?m)
                        (not (mover-near-crate ?m ?c))
                        (crate-at-warehouse ?c))
        :effect (and (not (mover-at-loadingBay ?m))
                     (mover-near-crate ?m ?c))
    )


    (:process move-to-crate-heavy
        ; mover1 and mover2 go toward a heavy crate together
        :parameters (?m1 - mover1 ?m2 - mover2 ?c - heavy)
        :precondition (and (mover-empty ?m1)
                        (= #t (/ (crate_distance ?c) 10))
                        (mover-empty ?m2)
                        (mover-at-loadingBay ?m1)
                        (not (mover-near-crate ?m1 ?c))
                        (mover-at-loadingBay ?m2)
                        (not (mover-near-crate ?m2 ?c))
                        (crate-at-warehouse ?c))
        :effect (and (not (mover-at-loadingBay ?m1))
                     (mover-near-crate ?m1 ?c)
                     (not (mover-at-loadingBay ?m2))
                     (mover-near-crate ?m2 ?c))
    )

    (:action pick-light
        ; moverx picks up a light crate
        :parameters (?m - mover ?c - light)
        :precondition (and (mover-empty ?m)
        		(= #t 1)
                       (mover-near-crate ?m ?c)
                       (crate-at-warehouse ?c))
        :effect (and (not (mover-empty ?m)) 
                     (not (crate-at-warehouse ?c))
                     (carry-light ?m ?c))
    )

    (:action pick-light-double
        ; mover1 and mover2 pick up a light crate together
        :parameters (?m1 - mover1 ?m2 - mover2 ?c - light)
        :precondition (and (mover-empty ?m1)
                        (= #t 1)
                        (mover-empty ?m2)
                        (mover-near-crate ?m1 ?c)
                        (mover-near-crate ?m2 ?c)
                        (crate-at-warehouse ?c))
        :effect (and (not (mover-empty ?m1)) 
                     (not (mover-empty ?m2))
                     (not (crate-at-warehouse ?c))
                     (carry-light-double ?m1 ?m2 ?c))
    )

    (:action pick-heavy
        ; mover1 and mover2 pick up a heavy crate together
        :parameters (?m1 - mover1 ?m2 - mover2 ?c - heavy)
        :precondition (and (crate-at-warehouse ?c) 
                        (= #t 1)
                        (mover-near-crate ?m1 ?c)
                        (mover-near-crate ?m2 ?c)
                        (mover-empty ?m1)
                        (mover-empty ?m2))
        :effect (and (not (mover-empty ?m1))
                     (not (mover-empty ?m2))
                     (carry-heavy ?m1 ?m2 ?c)
                     (not (crate-at-warehouse ?c)))
    )

    (:process move-to-loadingBay-light
        ; movers to carry a light crate to the loadingBay
        :parameters (?m - mover ?c - light ?l - loader)
        :precondition 
         (and 
          (= #t (/ (* (crate_distance ?c) (crate_weight ?c)) 100))
          (not (mover-at-loadingBay ?m)) 
          (carry-light ?m ?c)
          (loader-free ?l)
         )
        :effect (and 
        	 (mover-at-loadingBay ?m))
    )
    
        (:process move-to-loadingBay-light-double
        ; mover1 and mover2 carry a light crate to the loadingBay together
        :parameters (?m1 - mover1 ?m2 - mover2 ?c - light ?l - loader)
        :precondition (and (not (mover-at-loadingBay ?m1))
        		(= #t (/ (* (crate_distance ?c)(crate_weight ?c)) 150))
                        (not (mover-at-loadingBay ?m2))
                        (carry-light-double ?m1 ?m2 ?c)
                        (loader-free ?l))
        :effect (and (mover-at-loadingBay ?m1)
                     (mover-at-loadingBay ?m2))
    )

    (:process move-to-loadingBay-heavy
        ; mover1 and mover2 carry a heavy crate to the loadingBay together
        :parameters (?m1 - mover1 ?m2 - mover2 ?c - heavy ?l - loader)
        :precondition (and (not (mover-at-loadingBay ?m1))
        		(= #t (/ (* (crate_distance ?c)(crate_weight ?c)) 100))
                       (not (mover-at-loadingBay ?m2))
                       (carry-heavy ?m1 ?m2 ?c)
                       (loader-free ?l))
        :effect (and (mover-at-loadingBay ?m1)
                     (mover-at-loadingBay ?m2))
    )
    

    (:action drop-light
        ; moverx drops a light crate in the loadingBay
        :parameters (?m - mover ?c - light)
        :precondition (and (carry-light ?m ?c) 
                        (= #t 1)
                        (mover-at-loadingBay ?m))
        :effect (and (not (carry-light ?m ?c)) 
                        (crate-at-loadingBay ?c)
                        (mover-empty ?m))
    )

    (:action drop-light-double
        ; mover1 and mover2 drop a light crate in the loadingBay together
        :parameters (?m1 - mover1 ?m2 - mover2 ?c - light)
        :precondition (and (carry-light-double ?m1 ?m2 ?c) 
                        (= #t 1)
                        (mover-at-loadingBay ?m1)
                        (mover-at-loadingBay ?m2))
        :effect (and (not (carry-light-double ?m1 ?m2 ?c)) 
                       (crate-at-loadingBay ?c)
                       (mover-empty ?m1)
                       (mover-empty ?m2))
    )

    (:action drop-heavy
        ; mover1 and mover2 drop a heavy crate in the loadingBay together
        :parameters (?m1 - mover1 ?m2 - mover2 ?c - heavy)
        :precondition (and (carry-heavy ?m1 ?m2 ?c)
        		(= #t 1)
                       (mover-at-loadingBay ?m1)
                       (mover-at-loadingBay ?m2))
        :effect (and (not (carry-heavy ?m1 ?m2 ?c))
                     (crate-at-loadingBay ?c)
                     (mover-empty ?m1)
                     (mover-empty ?m2))
    )


    (:process load-light
        ; loader loads a crate from loadingBay to the conveyorBelt
        :parameters (?l - loader ?c - light)
        :precondition (and (crate-at-loadingBay ?c)
                        (= #t 4)
                        (not (crate-at-conveyorBelt ?c)))
        :effect (and (not (crate-at-loadingBay ?c))
                     (crate-at-conveyorBelt ?c)
                     (not (loader-free ?l))
                     (loader-free ?l))
    )

    (:process load-heavy
        ; loader loads a crate from loadingBay to the conveyorBelt
        :parameters (?l - loader ?c - heavy)
        :precondition (and (crate-at-loadingBay ?c)
                        (= #t 4)
                        (not (crate-at-conveyorBelt ?c)))
        :effect (and (not (crate-at-loadingBay ?c))
                     (crate-at-conveyorBelt ?c)
                     (not (loader-free ?l))
                     (loader-free ?l))
    )

    (:process load-fragile
        ; loader loads a crate from loadingBay to the conveyorBelt
        :parameters (?l - loader ?c - fragile)
        :precondition (and (crate-at-loadingBay ?c)
                        (= #t 6)
                        (not (crate-at-conveyorBelt ?c)))
        :effect (and (not (crate-at-loadingBay ?c))
                     (crate-at-conveyorBelt ?c)
                     (not (loader-free ?l))
                     (loader-free ?l))
    )
    
)

