@core @core_course @core_courseformat
Feature: Course index depending on role
  In order to quickly access the course structure
  As a user
  I need to see the current course structure in the course index.

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email                |
      | teacher1 | Teacher   | 1        | teacher1@example.com |
      | student1 | Student   | 1        | student1@example.com |
    And the following "course" exists:
      | fullname         | Course 1 |
      | shortname        | C1       |
      | category         | 0        |
      | enablecompletion | 1        |
      | numsections      | 4        |
    And the following "activities" exist:
      | activity | name                | intro                       | course | idnumber | section |
      | assign   | Activity sample 1   | Test assignment description | C1     | sample1  | 1       |
      | book     | Activity sample 2   | Test book description       | C1     | sample2  | 2       |
      | choice   | Activity sample 3   | Test choice description     | C1     | sample3  | 3       |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | student1 | C1     | student        |
      | teacher1 | C1     | editingteacher |

  @javascript
  Scenario: Course index is present on course and activities.
    Given I am on the "C1" "Course" page logged in as "teacher1"
    Given the "multilang" filter is "on"
    And the "multilang" filter applies to "content and headings"
    When I am on the "C1" "Course" page logged in as "teacher1"
    Then I should see "Open course index drawer"
    And I am on the "Activity sample 1" "assign activity editing" page
    And I set the field "Assignment name" in the "General" "fieldset" to "<span lang=\"en\" class=\"multilang\">Activity</span><span lang=\"de\" class=\"multilang\">Aktivität</span> sample 1"
    And I press "Save and display"
    And I should see "Open course index drawer"
    And I click on "Open course index drawer" "button"
    And I should see "Activity sample 1" in the "courseindex-content" "region"

  @javascript
  Scenario: Course index as a teacher
    Given I log in as "teacher1"
    And I am on "Course 1" course homepage
    When I click on "Open course index drawer" "button"
    Then I should see "Topic 1" in the "courseindex-content" "region"
    And I should see "Topic 2" in the "courseindex-content" "region"
    And I should see "Topic 3" in the "courseindex-content" "region"
    And I should see "Activity sample 1" in the "courseindex-content" "region"
    And I should see "Activity sample 2" in the "courseindex-content" "region"
    And I should see "Activity sample 3" in the "courseindex-content" "region"

  @javascript
  Scenario: Teacher can see hiden activities and sections
    Given I log in as "admin"
    And I am on "Course 1" course homepage with editing mode on
    And I hide section "2"
    And I open "Activity sample 3" actions menu
    And I click on "Hide" "link" in the "Activity sample 3" activity
    And I log out
    And I log in as "teacher1"
    And I am on "Course 1" course homepage
    When I click on "Open course index drawer" "button"
    Then I should see "Topic 1" in the "courseindex-content" "region"
    And I should see "Topic 2" in the "courseindex-content" "region"
    And I should see "Topic 3" in the "courseindex-content" "region"
    And I should see "Activity sample 1" in the "courseindex-content" "region"
    And I should see "Activity sample 2" in the "courseindex-content" "region"
    And I should see "Activity sample 3" in the "courseindex-content" "region"

  @javascript
  Scenario: Students can only see visible activies and sections
    Given I log in as "admin"
    And I am on "Course 1" course homepage with editing mode on
    And I hide section "2"
    And I open "Activity sample 3" actions menu
    And I click on "Hide" "link" in the "Activity sample 3" activity
    And I log out
    And I log in as "student1"
    And I am on "Course 1" course homepage
    When I click on "Open course index drawer" "button"
    Then I should see "Topic 1" in the "courseindex-content" "region"
    And I should not see "Topic 2" in the "courseindex-content" "region"
    And I should see "Topic 3" in the "courseindex-content" "region"
    And I should see "Activity sample 1" in the "courseindex-content" "region"
    And I should not see "Activity sample 2" in the "courseindex-content" "region"
    And I should not see "Activity sample 3" in the "courseindex-content" "region"

  @javascript
  Scenario: Delete an activity as a teacher
    Given I log in as "teacher1"
    And I am on "Course 1" course homepage with editing mode on
    When I delete "Activity sample 2" activity
    And I click on "Open course index drawer" "button"
    Then I should not see "Activity sample 2" in the "courseindex-content" "region"

  @javascript
  Scenario: Highlight sections are represented in the course index.
    Given I log in as "teacher1"
    And I am on "Course 1" course homepage with editing mode on
    And I turn section "2" highlighting on
    And I click on "Open course index drawer" "button"
    # Current section is only marked visually in the course index.
    And the "class" attribute of "#courseindex-content [data-for='section'][data-number='2']" "css_element" should contain "current"
    And I should not see "Highlighted" in the "#courseindex-content [data-for='section'][data-number='1']" "css_element"
    And I should see "Highlighted" in the "#courseindex-content [data-for='section'][data-number='2']" "css_element"
    When I turn section "1" highlighting on
    # Current section is only marked visually in the course index.
    Then the "class" attribute of "#courseindex-content [data-for='section'][data-number='1']" "css_element" should contain "current"
    And I should see "Highlighted" in the "#courseindex-content [data-for='section'][data-number='1']" "css_element"
    And I should not see "Highlighted" in the "#courseindex-content [data-for='section'][data-number='2']" "css_element"

  @javascript
  Scenario: Course index toggling
    Given the following "activities" exist:
      | activity | name                         | intro                       | course | idnumber | section |
      | book     | Second activity in section 1 | Test book description       | C1     | sample4  | 1       |
    And I log in as "teacher1"
    And I am on "Course 1" course homepage
    When I click on "Open course index drawer" "button"
    # Sections should be opened by default.
    Then I should see "Topic 1" in the "courseindex-content" "region"
    And I should see "Activity sample 1" in the "courseindex-content" "region"
    And I should see "Second activity in section 1" in the "courseindex-content" "region"
    And I should see "Topic 2" in the "courseindex-content" "region"
    And I should see "Activity sample 2" in the "courseindex-content" "region"
    And I should see "Topic 3" in the "courseindex-content" "region"
    And I should see "Activity sample 3" in the "courseindex-content" "region"
    # Collapse a section 1 via chevron.
    And I click on "Collapse" "link" in the ".courseindex-section[data-number='1']" "css_element"
    And I should see "Topic 1" in the "courseindex-content" "region"
    And I should not see "Activity sample 1" in the "courseindex-content" "region"
    And I should not see "Second activity in section 1" in the "courseindex-content" "region"
    And I should see "Topic 2" in the "courseindex-content" "region"
    And I should see "Activity sample 2" in the "courseindex-content" "region"
    And I should see "Topic 3" in the "courseindex-content" "region"
    And I should see "Activity sample 3" in the "courseindex-content" "region"
    # Uncollapse section 1 via Topic name.
    And I click on "Topic 1" "link" in the "courseindex-content" "region"
    And I should see "Topic 1" in the "courseindex-content" "region"
    And I should see "Activity sample 1" in the "courseindex-content" "region"
    And I should see "Second activity in section 1" in the "courseindex-content" "region"
    And I should see "Topic 2" in the "courseindex-content" "region"
    And I should see "Activity sample 2" in the "courseindex-content" "region"
    And I should see "Topic 3" in the "courseindex-content" "region"
    And I should see "Activity sample 3" in the "courseindex-content" "region"
    # Collapse a section 2 via chevron.
    And I click on "Collapse" "link" in the ".courseindex-section[data-number='2']" "css_element"
    And I should see "Topic 1" in the "courseindex-content" "region"
    And I should see "Activity sample 1" in the "courseindex-content" "region"
    And I should see "Second activity in section 1" in the "courseindex-content" "region"
    And I should see "Topic 2" in the "courseindex-content" "region"
    And I should not see "Activity sample 2" in the "courseindex-content" "region"
    And I should see "Topic 3" in the "courseindex-content" "region"
    And I should see "Activity sample 3" in the "courseindex-content" "region"
    # Uncollapse section 2 via chevron.
    And I click on "Expand" "link" in the ".courseindex-section[data-number='2']" "css_element"
    And I should see "Topic 1" in the "courseindex-content" "region"
    And I should see "Activity sample 1" in the "courseindex-content" "region"
    And I should see "Second activity in section 1" in the "courseindex-content" "region"
    And I should see "Topic 2" in the "courseindex-content" "region"
    And I should see "Activity sample 2" in the "courseindex-content" "region"
    And I should see "Topic 3" in the "courseindex-content" "region"
    And I should see "Activity sample 3" in the "courseindex-content" "region"

  @javascript
  Scenario: Course index section preferences
    Given I am on the "C1" "Course" page logged in as "teacher1"
    When I click on "Open course index drawer" "button"
    Then I should see "Topic 1" in the "courseindex-content" "region"
    And I should see "Activity sample 1" in the "courseindex-content" "region"
    And I should see "Topic 2" in the "courseindex-content" "region"
    And I should see "Activity sample 2" in the "courseindex-content" "region"
    And I should see "Topic 3" in the "courseindex-content" "region"
    And I should see "Activity sample 3" in the "courseindex-content" "region"
    # Collapse section 1.
    And I click on "Collapse" "link" in the ".courseindex-section[data-number='1']" "css_element"
    And I reload the page
    And I should see "Topic 1" in the "courseindex-content" "region"
    And I should not see "Activity sample 1" in the "courseindex-content" "region"
    And I should see "Topic 2" in the "courseindex-content" "region"
    And I should see "Activity sample 2" in the "courseindex-content" "region"
    And I should see "Topic 3" in the "courseindex-content" "region"
    And I should see "Activity sample 3" in the "courseindex-content" "region"
    # Collapse section 3.
    And I click on "Collapse" "link" in the ".courseindex-section[data-number='3']" "css_element"
    And I reload the page
    And I should see "Topic 1" in the "courseindex-content" "region"
    And I should not see "Activity sample 1" in the "courseindex-content" "region"
    And I should see "Topic 2" in the "courseindex-content" "region"
    And I should see "Activity sample 2" in the "courseindex-content" "region"
    And I should see "Topic 3" in the "courseindex-content" "region"
    And I should not see "Activity sample 3" in the "courseindex-content" "region"
    # Delete section 1
    And I turn editing mode on
    And I delete section "1"
    And I click on "Delete" "button" in the ".modal" "css_element"
    And I reload the page
    And I click on "Open course index drawer" "button"
    And I should not see "Activity sample 1" in the "courseindex-content" "region"
    And I should see "Topic 1" in the "courseindex-content" "region"
    And I should see "Activity sample 2" in the "courseindex-content" "region"
    And I should see "Topic 2" in the "courseindex-content" "region"
    And I should not see "Activity sample 3" in the "courseindex-content" "region"

  @javascript
  Scenario: Adding section should alter the course index
    Given I log in as "teacher1"
    And I am on "Course 1" course homepage with editing mode on
    And I click on "Open course index drawer" "button"
    When I click on "Add topic after" "link" in the "Topic 4" "section"
    Then I should see "Topic 5" in the "courseindex-content" "region"

  @javascript
  Scenario: Remove a section should alter the course index
    Given I log in as "teacher1"
    And I am on "Course 1" course homepage with editing mode on
    And I click on "Open course index drawer" "button"
    When I delete section "4"
    Then I should not see "Topic 4" in the "courseindex-content" "region"

  @javascript
  Scenario: Delete a previous section should alter the course index unnamed sections
    Given I log in as "teacher1"
    And I am on "Course 1" course homepage with editing mode on
    And I click on "Open course index drawer" "button"
    When I delete section "1"
    And I click on "Delete" "button" in the ".modal" "css_element"
    Then I should not see "Topic 4" in the "courseindex-content" "region"
    And I should not see "Activity sample 1" in the "courseindex-content" "region"
