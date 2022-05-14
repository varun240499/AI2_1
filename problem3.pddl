(define (problem groupd-problem3)
    (:domain groupd)
    (:objects
        ; defining the objects that are used 
        heavy heavy2 - heavy
        fragile - fragile
        light - light
        mover1 - mover1
        mover2 - mover2
        loader - loader
    )

    (:init
        ; Giving the intial conditions
        (mover-empty mover1)
        (mover-empty mover2)
        (loader-free loader)
        (mover-at-loadingBay mover1)
        (mover-at-loadingBay mover2)
        (crate-at-warehouse heavy)
        (crate-at-warehouse fragile)
        (crate-at-warehouse heavy2)
        (crate-at-warehouse light)

        ; Defining the weights of the crates
        (= (crate_weight heavy) 70)
        (= (crate_weight fragile) 80)
        (= (crate_weight heavy2) 60)
        (= (crate_weight light) 30)

        ; Determining the distance between the respective crates and the loadingbay
        (= (crate_distance heavy) 20)
        (= (crate_distance fragile) 20)
        (= (crate_distance heavy2) 30)
        (= (crate_distance light) 10)
    )

    (:goal
        ; Giving the goal
        (and (crate-at-conveyorBelt heavy)
             (crate-at-conveyorBelt fragile)
             (crate-at-conveyorBelt heavy2)
             (crate-at-conveyorBelt light)
        )
    )

    (:metric minimize
        (total-time)
    )
)
