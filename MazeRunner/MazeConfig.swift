//
//  MazeConfig.swift
//  MazeRunner
//
//  Created by Admin on 27/11/25.
//
import Foundation

struct MazeConfig {
    let map: [[Int]]
    let wallTextureName: String
    let floorTextureName: String
    let exitTextureName: String
    let playerTexturePrefix: String       // "run"
    let playerFrames: Int                 // 16
    let playerSpeed: CGFloat
    let giftInitialTime: Int              // e.g. 5
    let giftIncrement: Int                // e.g. +5 each
    
    var map_rows: Int { map.count }
    var map_cols: Int { map[0].count }
}
