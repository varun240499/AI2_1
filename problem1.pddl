(define (problem groupd-problem1)
    (:domain groupd)
    (:objects
        ; defining the objects that are used 
        heavy - heavy
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
        (crate-at-warehouse light)
         
        ; Defining the weights of the crates 
        (= (crate_weight heavy) 70)
        (= (crate_weight fragile) 20)
        (= (crate_weight light) 20)

        ; Determining the distance between the respective crates and the loadingbay
        (= (crate_distance heavy) 10)
        (= (crate_distance fragile) 20)
        (= (crate_distance light) 20)
    )

    (:goal
        ; Giving the goal 
        (and (crate-at-conveyorBelt heavy)
             (crate-at-conveyorBelt fragile)
             (crate-at-conveyorBelt light)
        )
    )

    (:metric minimize
        (total-time)
    )
)
