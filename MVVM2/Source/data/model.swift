//
//  model.swift
//  MyApp
//
//  Created by Trung on 22/10/2022.
//

import Foundation


// MARK: - MonsterElement
class Monster: Codable {
    let id: Int
    let name: Name
    let type: [TypeElement]
    let base: Base?
    let species, monsterDescription: String
    let evolution: Evolution
    let profile: Profile
    let image: Image
    var isFavorite = false

    enum CodingKeys: String, CodingKey {
        case id, name, type, base, species
        case monsterDescription = "description"
        case evolution, profile, image
    }
}

// MARK: - Base
struct Base: Codable {
    let hp, attack, defense, spAttack: Int
    let spDefense, speed: Int

    enum CodingKeys: String, CodingKey {
        case hp = "HP"
        case attack = "Attack"
        case defense = "Defense"
        case spAttack = "Sp. Attack"
        case spDefense = "Sp. Defense"
        case speed = "Speed"
    }
}

// MARK: - Evolution
struct Evolution: Codable {
    let next: [[String]]?
    let prev: [String]?
}

// MARK: - Image
struct Image: Codable {
    let sprite, thumbnail: String
    let hires: String?
}

// MARK: - Name
struct Name: Codable {
    let english, japanese, chinese, french: String
}

// MARK: - Profile
struct Profile: Codable {
    let height, weight: String
    let egg: [Egg]?
    let ability: [[String]]
    let gender: Gender
}

enum Egg: String, Codable {
    case amorphous = "Amorphous"
    case bug = "Bug"
    case ditto = "Ditto"
    case dragon = "Dragon"
    case fairy = "Fairy"
    case field = "Field"
    case flying = "Flying"
    case grass = "Grass"
    case humanLike = "Human-Like"
    case mineral = "Mineral"
    case monster = "Monster"
    case undiscovered = "Undiscovered"
    case water1 = "Water 1"
    case water2 = "Water 2"
    case water3 = "Water 3"
}

enum Gender: String, Codable {
    case genderless = "Genderless"
    case the001000 = "0.0:100.0"
    case the0100 = "0:100"
    case the1000 = "100:0"
    case the100000 = "100.0:0.0"
    case the125875 = "12.5:87.5"
    case the250750 = "25.0:75.0"
    case the2575 = "25:75"
    case the500500 = "50.0:50.0"
    case the5050 = "50:50"
    case the7525 = "75:25"
    case the875125 = "87.5:12.5"
}

enum TypeElement: String, Codable {
    case bug = "Bug"
    case dark = "Dark"
    case dragon = "Dragon"
    case electric = "Electric"
    case fairy = "Fairy"
    case fighting = "Fighting"
    case fire = "Fire"
    case flying = "Flying"
    case ghost = "Ghost"
    case grass = "Grass"
    case ground = "Ground"
    case ice = "Ice"
    case normal = "Normal"
    case poison = "Poison"
    case psychic = "Psychic"
    case rock = "Rock"
    case steel = "Steel"
    case water = "Water"
}

typealias Monsters = [Monster]
