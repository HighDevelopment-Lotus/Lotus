# krp-context
Simple, minimalistic event firing context menu

# Information
I really liked the look of these dark themed context menus but haven't seen alot released, now I'm sure mine isn't the best it's one of my first few public scripts and I feel it's really user friendly, I hope you all find a use for this and enjoy it!

![ShowCase](https://lithi.io/file/LY0d.png)
![ShowCase](https://lithi.io/file/60f7.png)
![ShowCase](https://lithi.io/file/dDnO.png)



# Setup
It's pretty simple, once you drop the krp-context resource into your resources folder just make sure you put

ensure krp-context

in your server.cfg. 

# Examples

https://streamable.com/w04k9z

Here is a base menu to show how it works, this is a kinda "figure it out" type of situation but I hope my examples work, the code below is what made the video above!
```
RegisterCommand("test", function(source, args, raw)
    TriggerEvent("krp-context:testMenu")
end)

RegisterNetEvent('krp-context:testMenu', function()
    TriggerEvent('krp-context:sendMenu', {
        {
            id = 1,
            header = "Main Title",
            txt = ""
        },
        {
            id = 2,
            header = "Sub Menu Button",
            txt = "This goes to a sub menu",
            params = {
                event = "krp-context:testMenu2",
                args = {
                    number = 1,
                    id = 2
                }
            }
        },
    })
end)

RegisterNetEvent('krp-context:testMenu2', function(data)
    local id = data.id
    local number = data.number
    TriggerEvent('krp-context:sendMenu', {
        {
            id = 1,
            header = "< Go Back",
            txt = "",
            params = {
                event = "krp-context:testMenu"
            }
        },
        {
            id = 2,
            header = "Number: "..number,
            txt = "ID: "..id
        },
    })
end)
```

# Known Bugs
No known bugs

# Support
Feel free to report any issues you have in the GitHub [Issues](https://github.com/nerohiro/krp-context/issues)

if you wish to add something to it, do a pull request on the github [Pull Requests](https://github.com/nerohiro/krp-context/pulls)

