//
//  Workouts.swift
//  GymBros
//

import Foundation
import SwiftyJSON

class Workout: NSObject {
  
  // MARK: - Properties
  var id: Int?
  var title: String?
  var time: String?
  var duration: Int?
  var location: String?
  var teamSize: Int?
  var owner_id: Int?
  var owner_name: String?
  var joined_workouts: [JoinedWorkout]?
  
  // Mark: - General
  
  init(swiftyjson: JSON){

    // Parse the json for each necessary parts
    self.parseWorkout(swiftyjson: swiftyjson)
    self.parseOwner(swiftyjson: swiftyjson)
    self.parseJoinedWorkouts(swiftyjson: swiftyjson)
    
    super.init()
  }
  
  // Function to parse workout information and set information accordingly
  func parseWorkout(swiftyjson: JSON){
    // Setting basic information
    self.id = swiftyjson["workout"]["id"].int!
    self.title = swiftyjson["workout"]["title"].string!
    self.duration = swiftyjson["workout"]["duration"].int!
    self.location = swiftyjson["workout"]["location"].string!
    self.teamSize = swiftyjson["workout"]["team_size"].int!
    
    // Setting time
    let formatter = DateFormatter()
    // Turning API date string into Date object
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
    let date = formatter.date(from: swiftyjson["workout"]["time"].string!)
    // Formatting date appropriately
    formatter.dateFormat = "MMM dd, HH:mm"
    self.time = formatter.string(from: date!)
    
  }
  
  // Function to parse owner information and set information accordingly
  func parseOwner(swiftyjson: JSON){
    // Setting owner information
    self.owner_id = swiftyjson["owner"]["id"].int!
    let fullOwnerName = "\(swiftyjson["owner"]["first_name"].string!) \(swiftyjson["owner"]["last_name"].string!)"
    self.owner_name = fullOwnerName
  }
  
  // Function parse joinedWorkouts and
  func parseJoinedWorkouts(swiftyjson: JSON){
    // Parsing joinedWorkouts
    let allJoinedWorkouts = swiftyjson["joined_workouts"].array!
    allJoinedWorkouts.forEach { joinedWorkout in
      let joinedWorkoutObject = JoinedWorkout(swiftyjsonArray: joinedWorkout)
      self.joined_workouts?.append(joinedWorkoutObject)
    }
    
  }
  
  // Function to check if from the returned json data that the current user is in the workout
  func hasJoined(user_id: Int) -> Bool {
    for joined_workout in self.joined_workouts! {
      if user_id == joined_workout.user_id! {
        return true
      }
    }
    return false
  }
  
  // Function to check if user_id is an owner of workout
  func isOwner(user_id: Int) -> Bool {
    return user_id == self.owner_id!
  }
  
}
