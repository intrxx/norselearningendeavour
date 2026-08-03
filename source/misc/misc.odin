package misc

import "core:fmt"

CONSTANT_NUMBER :: 12

misc_showcase :: proc() {
    fmt.println("This is a constant number: ", CONSTANT_NUMBER)

    new_hero := Hero {
        name = "MyHero",
        level = 1,
        entity_type = Entity_Type.Player,
        max_health = 100,
        health = 100,
    }

    new_not_using_hero := Not_Using_Hero {
        name = "MyHero",
        level = 1,
        health_component = {
            max_health = 100,
            health = 100,
        },
    }

    fmt.println("My hero: ", new_hero.name, new_hero.level, new_hero.health)

    new_enemy := Enemy {
        name = "MyHero",
        entity_type = Entity_Type.AI,
        max_health = 100,
        health = 100,
    }

    fmt.println("Printing enum: ", new_enemy.entity_type)

    my_union: Entity_Person = Hero(new_hero) 
    switch v in my_union {
        case Hero:
            fmt.println("I'm Hero")
        case Enemy:
            fmt.println("I'm Enemy")
    }

    hero_val, hero_val_ok := my_union.(Hero)
    if hero_val_ok {
        fmt.println("I'm Hero! ", hero_val.name)
    }

    if enemy_val, enemy_val_ok := my_union.(Enemy); enemy_val_ok  {
        fmt.println("I'm Enemy! ", enemy_val.name)
    } else {
        fmt.println("I'm not Enemy! ")
    }

    if hero_val, ok := &my_union.(Hero); ok {
        hero_val^.level += 1
        fmt.println("Hero Level Increased: ", hero_val.level)
    }

    time: Maybe(int)
    fmt.println(time) // nil
    if time_val, time_val_ok := time.?; time_val_ok {
	    // Use time_val.
    }
    time = 5
    fmt.println(time) // 5
    t := time.? // this asserts if value is nil
}

Hero :: struct {
    name: string,
    level: int,
    entity_type: Entity_Type,
    using health_component: Health_Component
}

Enemy :: struct {
    name: string,
    entity_type: Entity_Type,
    using health_component: Health_Component
}

Not_Using_Hero :: struct {
    name: string,
    level: int,
    health_component: Health_Component
}

Health_Component :: struct {
    max_health: int,
    health: int,
}

Entity_Type :: enum u8 { // Backing type can be specified, by default Odin uses int, we specify u8 here
    Player,
    AI
}

Entity_Person :: union {
    Hero,
    Enemy,
}