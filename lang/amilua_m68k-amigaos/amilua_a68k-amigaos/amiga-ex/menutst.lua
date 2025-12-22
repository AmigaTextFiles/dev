-- menu test

win = Siamiga.createwindow("Menutest", 0, 20, 400, 300)
win:addmenu(0,  "menu", "File")
win:addmenu(0,  "item",   "Open")
win:addmenu(11, "sub",      "Project")
win:addmenu(12, "sub",      "File")
win:addmenu(13, "item",   "Close", "C")
win:addmenu(0,  "item",   "barlabel")
win:addmenu(99, "item",   "Quit")
win:addmenu(0,  "menu", "Edit")
win:addmenu(21, "item",   "Cut", "X")
win:addmenu(22, "item",   "Copy", "C")
win:addmenu(23, "item",   "Paste", "V")
win:openwindow()

win:text(20,50, "Press right mouse button to see menu")

done = false
while done==false do
    win:waitmessage()
    while done==false do
        msg, menu = win:getmessage()
        if msg=="close" then
            done = true
        elseif msg == "menu" then
            print("menu", menu)
            if menu==99 then done = true end
        elseif msg=="refresh" then
            print("refresh event")
        end
    end
end
