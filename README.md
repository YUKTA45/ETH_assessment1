# ETH_assessment1

This Solidity smart contract implements a decentralized Railway Reservation System, allowing users to create trains and book tickets with basic functionalities.

## Description

The contract manages trains and bookings through mappings and structs. It supports the creation of trains with specified seat availability and allows passengers to book tickets, ensuring data integrity and preventing double bookings.

## Getting Started

### Executing program

To run this program, you can use Remix, an online Solidity IDE. To get started, go to the Remix website at https://remix.ethereum.org/.

Once you are on the Remix website, create a new file by clicking on the "+" icon in the left-hand sidebar. Save the file with a .sol extension (e.g., SafeVoting.sol). Copy and paste the following code into the file:

```javascript
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

```

To compile the code, click on the "Solidity Compiler" tab in the left-hand sidebar. Make sure the "Compiler" option is set to "0.8.7" (or another compatible version), and then click on the "Compile SafeVoting.sol" button.

Once the code is compiled, you can deploy the contract by clicking on the "Deploy & Run Transactions" tab in the left-hand sidebar. Select the "HelloWorld" contract from the dropdown menu, and then click on the "Deploy" button.

To use the RailwayReservationSystem contract, start by creating a new train using the createTrain function, providing a non-empty name and specifying the number of available seats. This action increments the trainCount and logs the creation of the train. Once a train is created, passengers can book tickets by calling bookTicket with the desired train ID. This function verifies the train's existence, availability of seats, and ensures no duplicate bookings from the same passenger. Each booking decrements available seats for the specified train and logs the booking details, including the passenger's address and assigned seat number. To check the current availability of seats for any train, use getAvailableSeats with the respective train ID. 

## Authors

Yukta
[@Chandigarh University](https://www.linkedin.com/in/Yukta-/)


## License

This project is licensed under the MIT License - see the LICENSE.md file for details
