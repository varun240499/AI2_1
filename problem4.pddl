(define (problem groupd-problem4)
    (:domain groupd)
    (:objects
        ; defining the objects that are used 
	  light1 light2 - light
        fragile1 fragile2 fragile3 fragile4 - fragile 
        heavy - heavy
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
        (crate-at-warehouse light1)
        (crate-at-warehouse fragile1)
        (crate-at-warehouse fragile2)
        (crate-at-warehouse fragile3)
        (crate-at-warehouse fragile4)
        (crate-at-warehouse light2)

        ; Defining the weights of the crates 
        (= (crate_weight light1) 30)
        (= (crate_weight fragile1) 20)
        (= (crate_weight fragile2) 30)
        (= (crate_weight fragile3) 20)
        (= (crate_weight fragile4) 30)
        (= (crate_weight light2) 20)

        ; Determining the distance between the respective crates and the loadingbay
        (= (crate_distance light1) 20)
        (= (crate_distance fragile1) 20)
        (= (crate_distance fragile2) 10)
        (= (crate_distance fragile3) 20)
        (= (crate_distance fragile4) 30)
        (= (crate_distance light2) 10)
    )

    (:goal
        ; Giving the goal 
        (and (crate-at-conveyorBelt light1)
             (crate-at-conveyorBelt fragile1)
             (crate-at-conveyorBelt fragile2)
             (crate-at-conveyorBelt fragile3)
             (crate-at-conveyorBelt fragile4)
             (crate-at-conveyorBelt light2)
        )
    )

    (:metric minimize
        (total-time)
    )
)
