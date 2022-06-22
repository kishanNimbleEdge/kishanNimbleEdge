//
//  DataLayerViewModel.swift
//  TestDemo
//
//  Created by Kishan Singh on 13/06/22.
//
import Foundation
#if canImport(UIKit)
import UIKit
#endif
    // Device Monitor Data
    // battery
    // is_device_charging() -> returns true if charging else false if discharging
    // get battery_level() -> returns battery level of device(float 64)
    // cpu
    // initialize_cpu_info() -> returns cpu info(mentioned in the struct below) in json string format
    // OverallCPUUsage float64
    // KernelVersion string
    // Model string // CPU model name
    // CPUArchitecture string
    // CPUNumber uint //Number of CPU in device
    // ClockSpeed     float32 //Overall CPU clock rate
    // IndividualClockSpeed []float32 // individual cpu clock rate
    // Cache     uint //CPU Cache Size
    // Cores     uint //number of cores in CPU
    // Threads   uint //number of threads in CPU
    //
    // // Some info regarding GPU in device
    // GPUVendor string
    // GPURendered string
    // GPUVersion string
    // GPULoad string
    // get_cpu_usage() -> in float64
    // temperature
    // get_cpu_temperature -> returns temperature in celcius(float64)
    // get_gpu_temperature -> in celcius(float64)
    // return_battery_temperature-> in celcius(float64)
    // memory
    // get_ram_info -> returns ram size(in GB, float) and data transfer speed(MHz, int)
    // get_rom_info ->
    // returns rom size(in GB, float) and data transfer speed (MHz, int)
    
protocol DataLayerViewModelProtocol {
    func isDeviceCharging() -> Bool
    func getBatterLevel() -> Float64
    // func initializeCpuInfo() -> objc
    func getCpuUsage() -> Float64
    // func getCpuTemperature() -> Float64
    // func getGpuTemperature() -> Float64
    // func returnBatteryTemperature() -> celcius(float64)
    // func getRamInfo() -> returns ram size(in GB, float) and data transfer speed(MHz, int)
    // func getRomInfo() -> returns rom size(in GB, float) and data transfer speed (MHz, int)
}
class DataLayerViewModel: DataLayerViewModelProtocol {
    
    func isDeviceCharging() -> Bool {
        #if canImport(UIKit)
        UIDevice.current.isBatteryMonitoringEnabled = true
        if (UIDevice.current.batteryState != .unplugged) {
            print("Device is charging.")
            return true
        } else {
            return false
        }
        #endif
        return false
    }
    
    func getBatterLevel() -> Float64 {
        #if canImport(UIKit)
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLevel = UIDevice.current.batteryLevel * 100
        return Double(batteryLevel)
        #endif
        return 0.0
    }
    func getCpuUsage() -> Float64 {
        #if canImport(UIKit)
        var totalUsageOfCPU: Double = 0.0
          var threadsList = UnsafeMutablePointer(mutating: [thread_act_t]())
          var threadsCount = mach_msg_type_number_t(0)
          let threadsResult = withUnsafeMutablePointer(to: &threadsList) {
            return $0.withMemoryRebound(to: thread_act_array_t?.self, capacity: 1) {
              task_threads(mach_task_self_, $0, &threadsCount)
            }
          }
          
          if threadsResult == KERN_SUCCESS {
            for index in 0..<threadsCount {
              var threadInfo = thread_basic_info()
              var threadInfoCount = mach_msg_type_number_t(THREAD_INFO_MAX)
              let infoResult = withUnsafeMutablePointer(to: &threadInfo) {
                $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                  thread_info(threadsList[Int(index)], thread_flavor_t(THREAD_BASIC_INFO), $0, &threadInfoCount)
                }
              }
              
              guard infoResult == KERN_SUCCESS else {
                break
              }
              
              let threadBasicInfo = threadInfo as thread_basic_info
              if threadBasicInfo.flags & TH_FLAGS_IDLE == 0 {
                totalUsageOfCPU = (totalUsageOfCPU + (Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE) * 100.0))
              }
            }
          }
          
          vm_deallocate(mach_task_self_, vm_address_t(UInt(bitPattern: threadsList)), vm_size_t(Int(threadsCount) * MemoryLayout<thread_t>.stride))
          return totalUsageOfCPU
        #endif
        return 0.0
    }
    
}
