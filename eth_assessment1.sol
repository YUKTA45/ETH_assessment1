// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract RailwayReservationSystem {
    struct Train {
        string name;
        uint256 availableSeats;
        bool exists;
    }

    struct Booking {
        address passenger;
        uint256 trainId;
        uint256 seatNumber;
        bool exists;
    }

    mapping(uint256 => Train) public trains;
    mapping(uint256 => Booking) public bookings;
    mapping(address => mapping(uint256 => bool)) public passengerBookings;
    uint256 public trainCount;
    uint256 public bookingCount;

    event TrainCreated(uint256 trainId, string name, uint256 availableSeats);
    event TicketBooked(uint256 bookingId, address indexed passenger, uint256 trainId, uint256 seatNumber);

    // Create a new train
    function createTrain(string calldata name, uint256 availableSeats) external {
        require(bytes(name).length > 0, "Train name cannot be empty");
        require(availableSeats > 0, "Train must have at least one available seat");

        trainCount++;
        trains[trainCount] = Train({
            name: name,
            availableSeats: availableSeats,
            exists: true
        });

        emit TrainCreated(trainCount, name, availableSeats);
    }

    // Book a ticket on a train
    function bookTicket(uint256 trainId) external {
        require(trains[trainId].exists, "Train does not exist");
        require(trains[trainId].availableSeats > 0, "No available seats on this train");
        require(!passengerBookings[msg.sender][trainId], "You have already booked a ticket on this train");

        trains[trainId].availableSeats--;
        bookingCount++;
        bookings[bookingCount] = Booking({
            passenger: msg.sender,
            trainId: trainId,
            seatNumber: trains[trainId].availableSeats + 1,
            exists: true
        });

        passengerBookings[msg.sender][trainId] = true;

        emit TicketBooked(bookingCount, msg.sender, trainId, trains[trainId].availableSeats + 1);

        // Ensure the seatNumber is correctly assigned
        assert(bookings[bookingCount].seatNumber > 0);
    }

    // Check the available seats of a train
    function getAvailableSeats(uint256 trainId) external view returns (uint256) {
        require(trains[trainId].exists, "Train does not exist");
        return trains[trainId].availableSeats;
    }

    // Check the details of a booking
    function getBookingDetails(uint256 bookingId) external view returns (address passenger, uint256 trainId, uint256 seatNumber) {
        require(bookings[bookingId].exists, "Booking does not exist");
        Booking memory booking = bookings[bookingId];
        return (booking.passenger, booking.trainId, booking.seatNumber);
    }

    // Example function using revert() statement
    function exampleRevert() external pure {
        // Revert with a custom error message
        revert("Transaction Reverted");
    }

    fallback() external payable {
        revert("Direct payments not allowed");
    }

    receive() external payable {
        revert("Direct payments not allowed");
    }
}
