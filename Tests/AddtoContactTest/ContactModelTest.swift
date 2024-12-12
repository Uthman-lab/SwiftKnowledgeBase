//
//  ContactModelTest.swift
//
//
//  Created by AMALITECH-PC-593 on 11/29/24.
//

import XCTest
@testable import AddToContact

final class ContactModelTest: XCTestCase {

    func test_ContactModel_DefaultInitialization() {
        // When
        let contact = Contact()

        // Then
        XCTAssertEqual(contact.givenName, "")
        XCTAssertEqual(contact.familyName, "")
        XCTAssertEqual(contact.middleName, "")
        XCTAssertEqual(contact.namePrefix, "")
        XCTAssertEqual(contact.nameSuffix, "")
        XCTAssertEqual(contact.nickname, "")
        XCTAssertEqual(contact.organizationName, "")
        XCTAssertEqual(contact.departmentName, "")
        XCTAssertEqual(contact.jobTitle, "")
        XCTAssertTrue(contact.phoneNumbers.isEmpty)
        XCTAssertTrue(contact.emailAddresses.isEmpty)
        XCTAssertTrue(contact.postalAddresses.isEmpty)
        XCTAssertNil(contact.birthday)
        XCTAssertEqual(contact.note, "")
        XCTAssertNil(contact.imageData)
    }

    func test_ContactModel_CustomInitialization() {
        // Given
        let givenName = "John"
        let familyName = "Doe"
        let phoneNumbers = ["123-456-7890", "098-765-4321"]
        let emailAddresses = ["john.doe@example.com"]
        let note = "A test contact"

        // When
        let contact = Contact(
            givenName: givenName,
            familyName: familyName,
            phoneNumbers: phoneNumbers,
            emailAddresses: emailAddresses,
            note: note
        )

        // Then
        XCTAssertEqual(contact.givenName, givenName)
        XCTAssertEqual(contact.familyName, familyName)
        XCTAssertEqual(contact.phoneNumbers, phoneNumbers)
        XCTAssertEqual(contact.emailAddresses, emailAddresses)
        XCTAssertEqual(contact.note, note)
    }

    func test_toCNMutableContact_ShouldHaveRequiredFields() {
        // Given
        let contact = Contact(
            givenName: "John",
            familyName: "Doe",
            phoneNumbers: ["123-456-7890"],
            emailAddresses: ["john.doe@example.com"],
            postalAddresses: ["123 Test St"],
            birthday: DateComponents(year: 1990, month: 1, day: 1),
            note: "Test note",
            imageData: Data([0x00, 0x01, 0x02])
        )

        // When
        let cnContact = contact.toCNMutableContact()

        // Then
        XCTAssertEqual(cnContact.givenName, "John")
        XCTAssertEqual(cnContact.familyName, "Doe")
        XCTAssertEqual(cnContact.phoneNumbers.count, 1)
        XCTAssertEqual(cnContact.phoneNumbers.first?.value.stringValue, "123-456-7890")
        XCTAssertEqual(cnContact.emailAddresses.count, 1)
        XCTAssertEqual(cnContact.emailAddresses.first?.value as?  String, "john.doe@example.com")
        XCTAssertEqual(cnContact.postalAddresses.count, 1)
        XCTAssertEqual(cnContact.postalAddresses.first?.value.street, "123 Test St")
        XCTAssertEqual(cnContact.birthday?.year, 1990)
        XCTAssertEqual(cnContact.birthday?.month, 1)
        XCTAssertEqual(cnContact.birthday?.day, 1)
        XCTAssertEqual(cnContact.note, "Test note")
        XCTAssertEqual(cnContact.imageData, Data([0x00, 0x01, 0x02]))
    }

    func test_toCNMutableContact_MustBeEmpty() {
        // Given
        let contact = Contact()

        // When
        let cnContact = contact.toCNMutableContact()

        // Then
        XCTAssertEqual(cnContact.givenName, "")
        XCTAssertEqual(cnContact.familyName, "")
        XCTAssertTrue(cnContact.phoneNumbers.isEmpty)
        XCTAssertTrue(cnContact.emailAddresses.isEmpty)
        XCTAssertTrue(cnContact.postalAddresses.isEmpty)
        XCTAssertNil(cnContact.birthday)
        XCTAssertEqual(cnContact.note, "")
        XCTAssertNil(cnContact.imageData)
    }

}
