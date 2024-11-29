
import XCTest
import Contacts
@testable import AddToContact
import ContactsUI

final class AddToContactTests: XCTestCase {
    
    func test_setContact_givenNameMustMatch() {
        // Given
        let controller = ContactViewController()
        let sampleContact = Contact(givenName: "John Doe")
        
        // When
        controller.setContact(sampleContact)
        
        // Then
        XCTAssertEqual(controller.contact.givenName, "John Doe")
    }
    
    func test_ContactViewController_mustContainCNContactViewController() {
        // Given
        let controller = ContactViewController()
        let sampleContact = Contact(givenName: "John Doe")
        controller.setContact(sampleContact)
        
        // When
        controller.viewDidLoad()
        
        // Then
        XCTAssertTrue(controller.viewControllers.first is CNContactViewController)
    }
}
