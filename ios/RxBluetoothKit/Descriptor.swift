// The MIT License (MIT)
//
// Copyright (c) 2016 Polidea
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import CoreBluetooth

/// Descriptor is a class implementing ReactiveX which wraps CoreBluetooth functions related to interaction with
/// [CBDescriptor](https://developer.apple.com/library/ios/documentation/CoreBluetooth/Reference/CBDescriptor_Class/)
/// Descriptors provide more information about a characteristic’s value.
public class Descriptor {

    let descriptor: RxDescriptorType

    /// Characteristic to which this descriptor belongs.
    public let characteristic: Characteristic

    /// Unique identifier of an object. Should be removed in 4.0
    @available(*, deprecated)
    public var objectId: UInt {
        return descriptor.objectId
    }

    /// The Bluetooth UUID of the `Descriptor` instance.
    public var uuid: CBUUID {
        return descriptor.uuid
    }

    /// The value of the descriptor. It can be written and read through functions on `Descriptor` instance.
    public var value: Any? {
        return descriptor.value
    }

    init(descriptor: RxDescriptorType, characteristic: Characteristic) {
        self.descriptor = descriptor
        self.characteristic = characteristic
    }

    /// Function that allow to monitor writes that happened for descriptor.
    /// - Returns: Observable that emits `Next` with `Descriptor` instance every time when write has happened.
    /// It's **infinite** stream, so `.Complete` is never called.
    public func monitorWrite() -> Observable<Descriptor> {
        return characteristic.service.peripheral.monitorWrite(for: self)
    }

    ///  Function that triggers write of data to descriptor. Write is called after subscribtion to `Observable` is made.
    ///  - Parameter data: `NSData` that'll be written to `Descriptor` instance
    ///  - Returns: Observable that emits `Next` with `Descriptor` instance, once value is written successfully.
    ///  Immediately after that `.Complete` is emitted.
    public func writeValue(_ data: Data) -> Observable<Descriptor> {
        return characteristic.service.peripheral.writeValue(data, for: self)
    }

    /// Function that allow to monitor value updates for `Descriptor` instance.
    /// - Returns: Observable that emits `Next` with `Descriptor` instance every time when value has changed.
    /// It's **infinite** stream, so `.Complete` is never called.
    public func monitorValueUpdate() -> Observable<Descriptor> {
        return characteristic.service.peripheral.monitorValueUpdate(for: self)
    }

    /// Function that triggers read of current value of the `Descriptor` instance.
    /// Read is called after subscription to `Observable` is made.
    /// - Returns: Observable which emits `Next` with given descriptor when value is ready to read.
    /// Immediately after that `.Complete` is emitted.
    public func readValue() -> Observable<Descriptor> {
        return characteristic.service.peripheral.readValue(for: self)
    }
}

extension Descriptor: Equatable {}

/// Compare two descriptors. Descriptors are the same when their UUIDs are the same.
///
/// - parameter lhs: First descriptor to compare
/// - parameter rhs: Second descriptor to compare
/// - returns: True if both descriptor are the same.
public func == (lhs: Descriptor, rhs: Descriptor) -> Bool {
    return lhs.descriptor == rhs.descriptor
}
