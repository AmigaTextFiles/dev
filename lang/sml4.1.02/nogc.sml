fun GarbageCollection boolean_var =

    let val current_state = ( CurrentState () )
        val GC_reference = (# GCMsgs current_state)

    in
        GC_reference := boolean_var;
        true
    end
