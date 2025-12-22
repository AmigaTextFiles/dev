      when entering a number into the backlog. See
                    gtlayout.h for more information.
                    Default: NULL

            SLIDER_KIND:

                LASL_FullCheck: TRUE will cause the code to rattle
                    through all possible slider settings, starting
                    from the minimum value, ending at the maximum value.
                    While this may be a good idea for a display
                    function to map slider levels to text strings
                    of varying length it might be a problem when
                    it comes to display a range of numbers from
                    1 to 40,000: the code will loop through
                    40,000 iterations trying to find the longest
                    string.

                    FALSE will cause the code to calculate the
                    longest level string based only on the
                    minimum and the maximum value to check.
                    While this is certainly a good a idea when
                    it comes to display a range of numbers from
                    1 to 40,000 as only two values will be
                    checked the code may fail to produce
                    accurate results for sliders using display
                    functions mapping slider levels to strings.

                    Default: TRUE

            LEVEL_KIND:

                All tags are supported which SLIDER_KIND supports.
                The gadget level display however, can only be aligned
                to the left border.

            LISTVIEW_KIND:

                LALV_ExtraLabels (STRPTR *) - Place extra line
                    labels at the right of the box. Terminate
                    this array with NULL.

                LALV_Labels (STRPTR *) - The labels to display
                    inside the box, you can pass this array of
                    strings in rather than passing an initialized
                    List of text via GTLV_Labels. Terminate
                    this array with NULL.

                LALV_CursorKey (BOOL) - Let the user operate this
                    listview using the cursor keys.

                    NOTE: there can be only one single listview
                          per window to sport this feature.

                    Default: FALSE

                LALV_Lines (LONG) - The number of text lines this
                    listview is to display.

                LALV_Link (LONG) - The Gadget ID of a string gadget
                    to attach to this listview. NOTE: you need to
                    add the Gadget in question before you add the
                    listview to refer to it or the layout routine
                    will get confused.
                    Passing the value NIL_LINK will create a listview
                    which displays the currently selected item, otherwise
                    you will get a read-only list.

                LALV_FirstLabel (LONG) - Locale string ID of the first
                    text to use as a list label. Works in conjunction
                    with LALV_LastLabel.

                LALV_LastLabel (LONG) - Locale string ID of the last
                    text to use as a list label. Works in conjunction
                    with LALV_FirstLabel. When building the interface the
                    code will loop from FirstLabel..LastLabel, look
                    up the corresponding locale strings and use the
                    data to make up the label text to appear in the
                    list.

                LALV_LabelTable (LONG *) - Pointer to an array of IDs
                    to use for building the listview contents. This requires
                    that a locale hook is provided with the layout handle.
                    The array is terminated by -1.

                LALV_MaxGrowX (LONG) - Maximum width of this object
                    measured in characters. When the first layout pass
                    is finished and there is still enough space left
                    to make the listview wider, the width is increased
                    until it hits the limit specified using this tag.

                    NOTE: there can be only one single listview
                          per window to sport this feature.

                    Default: 0

                LALV_MaxGrowY (LONG) - Maximum height of this object
                    measured in lines. When the first layout pass is
                    finished and there is till enough space left to
                    make the listview higher, the height is increased
                    until it hits the limit specified using this tag.

                    NOTE: there can be only one single listview
                          per window to sport this 