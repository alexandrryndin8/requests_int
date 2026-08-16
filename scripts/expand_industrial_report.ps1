param(
  [Parameter(Mandatory = $true)]
  [string]$TargetPath
)

Add-Type -AssemblyName System.IO.Compression.FileSystem

$content = @'
NpLC "Manash Kozybayev North Kazakhstan University"
International Campus

REPORT
on Industrial Practice No.2

Completed by Student of group ISU-23-1: Ryndin Alexandr

Reviewed by: Semenyuk Vladislav

Petropavlovsk, 2026

Table of Contents

Chapter 1. Introduction and Description of the Organization
Chapter 2. Individual Task from the Practice Supervisor
Chapter 3. Diploma Project Topic, Idea, and MVP Description
Chapter 4. Conclusion
Chapter 5. References

Chapter 1. Introduction and Description of the Organization

The industrial practice was completed at LLP "Center of Information Industry Solutions Integro." The organization works in the field of information technologies, automation of business processes, digital services, and technical solutions connected with access control systems. The company provides software and hardware solutions for educational institutions, organizations, and clients who need reliable systems for identification, accounting, and everyday operational management.

Integro can be described as a company that combines practical software development with applied technical support. Its work is not limited to the creation of websites or isolated applications. The company develops systems that solve real operational problems: collecting client requests, processing them, storing data, managing access devices, supporting administrators, and helping users receive services faster. This makes the organization a suitable place for industrial practice, because the tasks are connected with real business requirements and not only with theoretical programming exercises.

The company's activity is especially relevant for educational institutions. Schools and colleges often need access devices such as smart cards, bracelets, and key fobs. These devices are used by students and staff members to interact with access control infrastructure. However, the process of ordering, issuing, replacing, and tracking these devices can become difficult if it is handled manually. Employees have to collect personal information, check requests, update statuses, monitor stock, and communicate with users. A digital system can significantly reduce this workload.

During the practice, the main project was connected with the development and improvement of a web-based system for processing applications for access devices. The system was intended to serve two groups of users. The first group includes regular users: school students, college students, staff members, and other clients who need to submit an application for an access device. The second group includes administrators and company employees who process applications, update statuses, manage stock, and maintain reference data.

The project was closely connected with the actual needs of the organization. It was necessary to create a platform that could collect applications through a public website, store them in a database, allow users to check their request status, and provide administrators with tools for internal processing. Later, the project was expanded with multilingual support, an AI assistant, stock accounting, product price management, and automatic warehouse notifications.

The practice at Integro gave an opportunity to work with a real full-stack project. The work included frontend development, backend API development, database interaction, user interface improvement, debugging, and adapting the system to changing requirements. This made the practice valuable from both technical and professional points of view.

The organization's workflow also demonstrated how software development is performed in a business environment. Requirements were discussed with the company supervisor, then implemented, tested, and corrected after feedback. Several meetings were held during the practice period, and each meeting helped clarify what should be improved in the system. This process showed that development is not only about writing code, but also about understanding the client's needs, analyzing feedback, fixing mistakes, and making the system convenient for real users.

Chapter 2. Individual Task from the Practice Supervisor

The individual task from the practice supervisor was to participate in the development and improvement of a full-stack web application for managing applications for access devices. The project had to include both public functionality for users and internal functionality for administrators. The work required understanding the existing project structure, improving the user interface, developing new features, fixing bugs, and connecting frontend functionality with backend API routes and database logic.

At the beginning of the practice, a meeting was held with the company management and the practice supervisor. During this meeting, the main requirements were discussed. The system had to collect applications for access devices, support several user categories, provide request tracking, and allow administrators to process requests from a single interface. The first technical task was focused on improving the public application form and the administrative panel.

One of the first tasks was connected with the public application form. The form had to be convenient for different user roles: school students, college students, and staff members. Depending on the selected role, the form had to show different fields. For school students, the user selects a class and a letter. For college students, the user enters a group. For staff members, the user selects a department. The form also includes personal data, educational institution selection, and access device selection.

During the implementation of the form, special attention was paid to user experience. Selection buttons were improved visually so that the selected option was clearly readable. The design of role selection, class selection, and staff department selection was unified. This made the interface more consistent and easier to use. The form was also adapted to the general visual style of the website, with a white card layout, clear labels, focus states, and responsive spacing.

Another task was the status-checking page. After a user submits an application, the system generates a track number and password. These two values allow the user to check the status of the request without contacting the company. The page for checking the request status was redesigned in the same style as the main application form. The layout was improved with a card structure, clear input fields, and a consistent submit button. The functionality remained unchanged, but the visual quality and usability were improved.

The login page was also updated visually. The requirement was not to change the authentication logic, but to adapt the design to match the rest of the project. The login form was placed inside a styled card, input fields and buttons were improved, and the layout was centered on the page. This task helped improve the consistency of the interface while preserving the existing backend authentication behavior.

A significant part of the individual task was connected with the administrative panel. The admin panel is used by company employees to process applications and manage system data. During the practice, the panel was improved and expanded. The interface includes sections for requests, educational institutions, deleted requests, analytics, product prices, users, and stock management. The sidebar navigation was structured so that administrators could quickly switch between sections.

The stock management section became one of the most important new parts of the admin panel. It allows administrators to add product receipts, view current stock, and monitor recent stock movements. Products include cards, bracelets, key fobs, and bracelet color variants. The section displays remaining quantities and highlights low-stock items. This functionality is useful because the company needs to know how many access devices are available before processing requests.

Additional warehouse logic was implemented for automatic notifications. The company needs consumables connected with the production and preparation of cards. For example, after every 1000 received cards, the system creates a reminder that a cleaning device should be ordered. After every 135 received cards, the system calculates how many printer ribbons are needed and creates a notification for administrators. This logic was implemented on the backend side so that the counter is stored in the database and does not disappear after page reloads.

The notification system was added to the stock section. Unread notifications are displayed at the top of the stock page. Administrators can mark notifications as read. When a notification is marked as read, it disappears from the active list and is stored in the database with the read date and the administrator who marked it. This feature showed how internal business rules can be turned into practical software functionality.

Another important area of work was multilingual support. A language switcher was added to the public navigation bar. The public part of the website was adapted to support Russian and Kazakh languages. The translated parts include the main page, application form, status-checking page, and chat interface. At the same time, the login page and administrative panel were intentionally not translated because they are internal tools for company employees.

The AI assistant was also improved as part of the task. It was implemented as a floating chat component on the public pages of the website. The assistant provides consultation to users and answers frequently asked questions about applications, available devices, office address, working hours, payment methods, and request tracking. The chat interface includes a header, an initial assistant message, a text area for user input, loading state, error messages, and a compact floating button.

The AI assistant was connected with a server-side API route. The frontend sends the conversation history to the API, and the backend returns the assistant's response. The assistant uses a system prompt that limits answers to company-related information. This is important because the assistant should not provide unrelated or incorrect information. Later, the chat title, initial message, and input placeholder were adapted to the selected language of the public website.

The work also included backend and database tasks. PostgreSQL was used as the main database, while Prisma ORM was used for server-side database operations. API routes were used for submitting applications, tracking statuses, managing stock, receiving product data, handling login, and working with notifications. During the practice, knowledge of database structure, transactions, raw SQL queries, and Prisma models was improved.

Several practical skills were gained during the individual task. First, frontend development skills were improved through work with Vue.js, Nuxt 3, TypeScript, and Tailwind CSS. Second, backend development skills were strengthened through API route implementation, request validation, and database operations. Third, debugging skills improved because several issues had to be found and fixed during testing. Finally, experience was gained in working with real requirements, where functionality often changes after feedback from the supervisor.

The practice also helped develop professional skills. It was necessary to read and understand existing code, avoid breaking already working functionality, and make changes carefully. The work required attention to detail, especially when improving visual design without changing business logic. It also required responsibility, because errors in the application form, status checking, or stock management could affect real users and administrators.

As a result, the individual task was not limited to one small feature. It included participation in the development of a real full-stack system, improvement of existing pages, creation of new admin tools, development of backend logic, and adaptation of the interface to business needs.

Chapter 3. Diploma Project Topic, Idea, and MVP Description

The topic of the project is the development of a digital system for submitting, processing, and managing applications for access devices. The project is based on the need to automate the interaction between clients and the company when ordering smart cards, bracelets, and key fobs. These devices are used in educational institutions and organizations, and therefore the process of issuing them should be organized, traceable, and convenient.

The main idea of the project is to replace manual or semi-manual request processing with a centralized web platform. Before such a system, applications could be collected through different channels, manually checked, and processed without a unified digital workflow. This approach increases the probability of mistakes, duplicate requests, lost information, and delays. The developed system solves these problems by providing one digital environment for users and administrators.

The project's MVP is not only a simple form. It is a complete minimal system that contains all core functions required for real use: public application submission, request tracking, administrator processing, database storage, product management, stock accounting, automatic notifications, multilingual interface support, and AI-based consultation. These parts together form a working product that can be used and later expanded.

The first key part of the MVP is the public website. The public website is intended for users who need to order an access device. The main page introduces the service and provides navigation to the application form and request status page. The design is simple and direct, because the main purpose of the website is not marketing but practical service delivery. The user should quickly understand where to submit an application and where to check its status.

The application form is the central element of the public website. It collects the user's surname, name, patronymic, role, educational institution, class or group, and selected device. The form supports different categories of applicants. If the user is a school student, the system displays class and letter selection. If the user is a college student, the group field is shown. If the user is a staff member, the department selection is displayed. This conditional interface reduces confusion and shows only relevant fields.

Educational institution selection is implemented through a searchable list. This is important because the list of schools and colleges may be long. Instead of forcing the user to scroll through all options, the interface allows searching by name. The selected institution can also be cancelled and changed. This improves usability and reduces the probability of incorrect submissions.

The device selection section allows the user to choose an access device. The system supports products such as cards, bracelets, and key fobs. If a bracelet is selected, the form can additionally request a color. Product data is loaded from the backend, which means that the public form can reflect the current product list and availability. This is better than hardcoding all products in the frontend, because administrators can manage products separately.

The form includes validation logic. The user must fill required fields, and name fields are checked to contain valid Russian or Kazakh letters and a hyphen. For students, the group field is validated. These checks are important because incorrect data can make request processing difficult for administrators. Validation improves the quality of data stored in the database.

After submitting the application, the backend creates a request and returns a track number and password. These values are shown to the user in a modal window. The track number and password are important because they allow the user to check the request status later. The modal also includes a button for copying the credentials. This small interface detail improves user convenience and reduces the risk that the user will lose the information.

The second key part of the MVP is the request status page. Users can enter their track number and password to check the current status of the application. This feature is useful for both users and company employees. Users do not need to call the company for every status update, and administrators receive fewer repetitive questions. The status page also displays additional messages depending on the status. For example, if the request is completed, the page can show information about where and when the device can be collected.

The third key part of the MVP is the administrative panel. This part is intended for internal company use. The admin panel includes authentication, so only authorized employees can access it. After login, administrators can view submitted requests in a table. Each request contains important information: applicant name, educational institution, class or group, selected device, source of request, current status, creation date, and modification date.

The request table allows administrators to process applications more efficiently. Instead of searching through messages or paper records, employees can view all requests in one place. They can update statuses, monitor new applications, and work with deleted records. The administrative panel therefore becomes the central working tool for daily request processing.

The admin panel also includes a section for educational institutions. This section allows managing the list of schools and colleges used in the public form. Such functionality is important because the list can change over time. If a new institution is added or an existing one needs correction, administrators can update the data without changing the frontend code.

Deleted requests are handled separately. This is useful because accidental deletion should not lead to permanent loss of important data. The deleted requests section allows administrators to review and restore records if needed. This feature adds a layer of safety to the system and improves reliability.

The product price management section allows authorized administrators to update device prices and availability. Product data affects what users see in the public form and what administrators see in internal tools. By separating product management from code, the system becomes more flexible and easier to maintain.

The stock management module is another important part of the MVP. It was developed to help administrators monitor access device inventory. The module displays current stock quantities, colors, prices, and update dates. Low-stock items are highlighted so that administrators can notice them quickly. This is important because requests cannot be processed properly if there are not enough devices available.

Stock receipts can be added through a form. The administrator selects a device, optionally selects a bracelet color, enters the quantity, and can add a comment. After submission, the backend updates the product quantity and creates a stock movement record. Recent movements are displayed in a table, which provides a history of receipts and automatic write-offs. This makes warehouse operations more transparent.

The stock module also supports automatic notifications. This functionality was added because some consumables must be ordered after a certain number of cards are received. A counter is stored in the database. When cards are added to stock, the backend increases the counter. If the counter reaches a threshold, the system creates a notification. The counter then stores the remainder and continues counting. This allows the system to correctly handle receipts of 100, 200, 700, or even 2500 cards.

For example, if the threshold for a cleaning device is 1000 cards, and the administrator adds 100 cards, the counter becomes 100. If later 200 cards are added, the counter becomes 300. If later 700 cards are added, the counter reaches 1000 and a notification is created. If 2500 cards are added at once, the system calculates how many thresholds were passed and stores the remaining amount for the next cycle.

A similar logic is used for printer ribbons. One printer ribbon is needed for every 135 cards. The system counts received cards and creates a notification with the exact number of ribbons that should be purchased. For example, if 945 cards are counted, the notification says that 7 printer ribbons are needed. This is a practical example of how business rules can be automated in software.

The notification system is shown in the stock section of the admin panel. Notifications are displayed in a separate block at the top of the page. Each notification contains a message and the creation date. Administrators can mark notifications as read. Read notifications are hidden from the active list, but their data remains in the database. This helps maintain a history of internal reminders.

Another major part of the project is the AI assistant. The assistant is displayed as a floating chat widget on public pages. It is designed to answer common questions from users. The assistant can explain how to submit an application, how to check the status, what devices are available, where the office is located, what the working hours are, and how payment is accepted. This reduces the number of repeated questions and improves the user experience.

The AI assistant is implemented as a frontend component connected to a backend API route. The component stores visible chat messages and sends conversation history to the backend. The backend uses a system prompt that contains company-related rules and information. This prompt limits the assistant's answers and makes them more relevant to the website. The assistant is instructed to be polite, answer in the same language as the user, and recommend calling the company if it does not know the answer.

The chat interface includes an initial greeting, message bubbles, loading state, error handling, and a text area for input. The first message is hardcoded on the client side and changes depending on the selected language of the website. The title of the chat and the input placeholder are also localized. This makes the assistant feel integrated into the website rather than being a separate external element.

Localization is another important feature of the MVP. The public part of the website supports Russian and Kazakh languages. A language switcher is placed in the navigation bar. The selected language is stored locally, so the user's choice is preserved. The main page, application form, status-checking page, and chat interface were adapted to display text depending on the selected language.

The localization was implemented carefully so that functional values sent to the backend would not change unexpectedly. For example, products, roles, statuses, and internal database values remain stable, while only visible text changes. This approach reduces the risk of breaking backend logic while still providing a multilingual interface for users.

The backend architecture of the MVP is based on Nuxt server API routes. These routes handle application submission, status checking, authentication, product loading, stock receipts, notification reading, and other operations. The backend acts as the connection point between the frontend and PostgreSQL database. This separation makes the application easier to maintain because frontend components do not directly access the database.

PostgreSQL is used as the main database. The database stores requests, schools, administrators, products, stock movements, counters, and notifications. Prisma ORM is used for most database operations, while raw SQL is used in some cases where direct table access or row locking is required. For example, stock threshold counters use a database-level lock to prevent incorrect calculations when multiple receipts are processed at the same time.

Security and reliability were also considered in the MVP. The admin panel is protected by authentication. API routes check whether a user is authorized before returning administrative data. Public forms use validation and reCAPTCHA protection to reduce spam and incorrect submissions. Passwords used for request tracking are generated and stored in a secure way.

The MVP provides a clear workflow. A user submits an application through the public form. The backend validates the data and saves the request. The user receives a track number and password. The administrator sees the request in the admin panel and processes it. If the request is completed, the user can check the status on the website. At the same time, the stock module helps administrators monitor available devices and receive reminders about consumables.

The project demonstrates how a small business process can be transformed into a digital system. Instead of separate manual actions, the system creates a structured workflow with data storage, tracking, administration, and notifications. It improves transparency because every request and stock movement can be viewed. It improves user convenience because users can submit and track requests online. It improves internal work because administrators have tools for processing and monitoring.

From a technical point of view, the project is valuable because it combines several areas of full-stack development. It includes frontend interfaces, reactive forms, conditional rendering, responsive design, API routes, authentication, database models, SQL queries, transactions, multilingual support, and AI integration. Each part of the project required different skills, and together they formed a complete practical system.

The MVP can be expanded in the future. Possible improvements include more detailed analytics, role-based permissions for administrators, export of reports, email or Telegram notifications for users, advanced search and filtering, better notification history, and integration with external payment systems. However, the current MVP already includes enough functionality to solve the main business problem and support real work.

The development of the MVP can also be described through several user scenarios. The first scenario is the submission of a new application by a school student. The student opens the public website, chooses the option to submit an application, selects the role of school student, searches for the educational institution, selects the class and class letter, chooses the required access device, and submits the form. The system checks that the required fields are filled correctly and then creates a record in the database. After that, the student receives a track number and password. This scenario shows how the system replaces a manual application process with a structured digital form.

The second scenario is the submission of an application by a college student. In this case, the form behaves differently. Instead of class and letter selection, the user enters a group name. This demonstrates the flexibility of the interface. One form can serve different categories of users without forcing all users to fill the same set of fields. Such conditional logic is important for usability because it reduces visual noise and prevents users from entering irrelevant information.

The third scenario is the submission of an application by a staff member. Staff members do not need to enter a class or student group. Instead, they select a department, such as administration, teaching staff, technical staff, or another department. This scenario shows that the system can support not only students but also employees of educational institutions. The system stores the selected department as part of the application data, which helps administrators understand who the request belongs to.

Another scenario is request tracking. A user who has already submitted an application opens the tracking page and enters the track number and password. If the data is correct, the system returns the current request status. If the request is accepted, the user is informed that the order is being processed. If it is completed, the user receives information about where the device can be collected. If it has already been issued, the user receives a final message. This scenario improves communication between the company and users.

The administrator scenario begins with authentication. The administrator opens the login page, enters credentials, and receives access to the admin panel. After authorization, the administrator can view requests and work with them. The request table acts as a central workspace. It helps employees process applications, update statuses, and keep records organized. Without such a table, administrators would need to search for information manually, which would take more time and increase the risk of errors.

The stock administrator scenario is also important. When new products arrive, the administrator opens the stock section, selects the product, enters the quantity, adds a note if necessary, and submits the receipt. The system updates stock quantities and creates a movement history record. This movement history is useful because it shows when products were added or automatically written off. It also supports internal control and accountability.

The automatic notification scenario demonstrates how business rules are implemented in software. The company knows that after a certain number of received cards, additional consumables are required. Instead of asking employees to remember these thresholds manually, the system counts cards in the background. When the threshold is reached, the system creates a notification. This reduces the chance that employees will forget to order necessary materials.

The MVP architecture can be divided into three logical layers. The first layer is the user interface. It includes Vue components, Nuxt pages, Tailwind CSS styles, forms, tables, buttons, modals, and chat elements. This layer is responsible for interaction with users and administrators. The second layer is the server API layer. It receives requests from the frontend, validates data, applies business logic, and communicates with the database. The third layer is the database layer, where information is stored permanently.

The separation of these layers makes the system easier to maintain. For example, the design of the form can be changed without changing the database. The database structure can be extended with new tables without rewriting the entire frontend. Business rules such as stock notifications can be implemented on the server side and remain reliable even if the user refreshes the page or closes the browser.

One of the important technical decisions was to keep business-critical logic on the backend. The stock threshold counters are a good example. If counters were stored only in the browser, they would be lost after page reload or would differ for different administrators. By storing them in PostgreSQL, the system guarantees that every receipt is counted once and that the result is shared for all administrators. This is more reliable and more suitable for real use.

Another technical decision was to use database transactions for stock receipt processing. When a receipt is submitted, several actions must happen together: product quantity is updated, a stock movement is created, counters are updated, and notifications may be created. If one of these steps fails, the whole operation should not leave the database in an inconsistent state. Transactions help keep these operations atomic and reliable.

The notification logic for printer ribbons is an example of a calculation based on business rules. The company uses one ribbon for every 135 cards. Therefore, when the accumulated number of cards reaches a multiple of 135, the system calculates how many ribbons are required. If 945 cards are counted, the system calculates 945 divided by 135 and creates a message that 7 ribbons should be purchased. This makes the notification more useful than a simple reminder.

The AI assistant is also part of the MVP from the point of view of user support. Many users may have similar questions: how to submit an application, where to collect the device, what the working hours are, and what to do if they lost the track number. A chat assistant provides immediate help. Even if it does not replace human support completely, it reduces the number of simple repetitive questions and improves the accessibility of information.

The assistant was designed with restrictions. It should answer only based on company-related information. It should not invent unrelated facts or provide long unnecessary explanations. If the assistant does not know the answer, it should recommend contacting the company by phone during working hours. This approach is important because an AI assistant on a business website must be helpful but controlled.

The localization feature improves accessibility for users in Kazakhstan. Since the public audience may include Russian-speaking and Kazakh-speaking users, the website should support both languages. The project implements a simple but practical localization approach. The language switcher changes visible text on public pages, while backend values remain stable. This reduces technical risk and keeps the system compatible with existing data.

During the development of the MVP, attention was paid to visual consistency. Several pages were redesigned to follow the same style: white cards, clear headings, blue primary buttons, consistent input fields, and readable spacing. This matters because users understand the system faster when pages look and behave consistently. A consistent interface also makes the project look more professional.

Testing and debugging were important parts of the work. Several issues appeared during development, especially in the admin panel and stock section. Some problems were related to interface states, some to database logic, and some to generated Prisma client behavior. Solving these issues required reading error messages carefully, checking API routes, inspecting database tables, and changing implementation details without breaking existing functionality.

The project also required careful handling of existing code. Since the system already had working parts, new features had to be added without changing unrelated functionality. For example, when the login page was redesigned, the authentication logic was not changed. When the application form was localized, values sent to the backend were preserved. This approach is important in real projects because unnecessary changes can create new bugs.

From the business point of view, the MVP brings several benefits. It reduces manual data collection, improves request tracking, provides administrators with a centralized workspace, helps monitor stock, and gives users quick answers through the AI assistant. These benefits are practical and directly connected with the organization’s workflow.

From the educational point of view, the MVP is useful because it includes many aspects of software engineering. It is not only a frontend layout and not only a backend database. It is a combined system where user experience, business logic, database design, server routes, authentication, localization, and AI integration must work together. This makes the project suitable for industrial practice and for demonstrating full-stack development skills.

The final MVP can be evaluated as a working internal and public service. Users can submit and track applications, while administrators can process them and manage supporting data. The system is ready for further improvement, but the core functions are already present. The project therefore satisfies the main requirement of an MVP: it provides enough functionality to solve the essential problem and can be used as a foundation for future development.

Chapter 4. Conclusion

During the industrial practice, a full-stack web system for processing applications for access devices was developed and improved. The project included a public application form, request tracking page, administrative panel, database logic, stock management, automatic notifications, multilingual interface support, and an AI assistant.

The practice provided valuable experience in real project development. It helped strengthen knowledge of Vue.js, Nuxt.js, TypeScript, Tailwind CSS, PostgreSQL, Prisma ORM, and backend API development. It also gave practical understanding of how business requirements are transformed into working software features.

The completed work can be considered useful for the organization because it simplifies the process of collecting and managing applications, reduces manual work for administrators, improves transparency of request processing, and makes the service more convenient for users.

The project also demonstrated the importance of iterative development. Requirements changed during the practice, and the system had to be adapted to new needs. This helped develop skills in debugging, refactoring, communication, and careful implementation of new functionality without breaking existing features.

Chapter 5. References

1. Nuxt Documentation. https://nuxt.com/docs
2. Vue.js Documentation. https://vuejs.org
3. Tailwind CSS Documentation. https://tailwindcss.com/docs
4. Prisma ORM Documentation. https://www.prisma.io/docs
5. PostgreSQL Documentation. https://www.postgresql.org/docs
6. TypeScript Documentation. https://www.typescriptlang.org/docs
7. OpenAI API Documentation. https://platform.openai.com/docs
8. MDN Web Docs. https://developer.mozilla.org
9. Google reCAPTCHA Documentation. https://developers.google.com/recaptcha
10. Nuxt Server API Documentation. https://nuxt.com/docs/guide/directory-structure/server
'@

function ConvertTo-ParagraphXml {
  param(
    [string]$Text,
    [string]$Style = '',
    [bool]$PageBreak = $false
  )

  $escaped = [System.Security.SecurityElement]::Escape($Text)
  $pPr = ''

  if ($Style) {
    $pPr = "<w:pPr><w:pStyle w:val=`"$Style`"/><w:spacing w:after=`"160`"/></w:pPr>"
  } else {
    $pPr = '<w:pPr><w:spacing w:after="160"/><w:jc w:val="both"/></w:pPr>'
  }

  $breakXml = ''
  if ($PageBreak) {
    $breakXml = '<w:r><w:br w:type="page"/></w:r>'
  }

  return "<w:p>$pPr$breakXml<w:r><w:t xml:space=`"preserve`">$escaped</w:t></w:r></w:p>"
}

$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("docx-expand-" + [guid]::NewGuid().ToString())
[System.IO.Directory]::CreateDirectory($tempRoot) | Out-Null
[System.IO.Compression.ZipFile]::ExtractToDirectory($TargetPath, $tempRoot)

$documentPath = Join-Path $tempRoot 'word/document.xml'
$oldXml = Get-Content -LiteralPath $documentPath -Raw -Encoding UTF8
$sectPrMatch = [regex]::Match($oldXml, '<w:sectPr[\s\S]*?</w:sectPr>')
if ($sectPrMatch.Success) {
  $sectPr = $sectPrMatch.Value
} else {
  $sectPr = '<w:sectPr><w:pgSz w:w="11906" w:h="16838"/><w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440" w:header="708" w:footer="708" w:gutter="0"/></w:sectPr>'
}

$paragraphs = $content -split "`r?`n`r?`n"
$bodyParts = New-Object System.Collections.Generic.List[string]

foreach ($paragraph in $paragraphs) {
  $text = ($paragraph -replace "`r", '').Trim()
  if (-not $text) { continue }

  $style = ''
  $pageBreak = $false

  if ($text -eq 'REPORT') {
    $style = 'Title'
  } elseif ($text -match '^Chapter [1-5]\.') {
    $style = 'Heading1'
    $pageBreak = $true
  } elseif ($text -in @('Table of Contents')) {
    $style = 'Heading1'
    $pageBreak = $true
  }

  foreach ($line in ($text -split "`n")) {
    $lineText = $line.Trim()
    if (-not $lineText) { continue }
    $bodyParts.Add((ConvertTo-ParagraphXml -Text $lineText -Style $style -PageBreak $pageBreak))
    $pageBreak = $false
  }
}

$bodyXml = ($bodyParts -join "`n") + "`n" + $sectPr
$newXml = "<?xml version=`"1.0`" encoding=`"UTF-8`" standalone=`"yes`"?><w:document xmlns:wpc=`"http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas`" xmlns:cx=`"http://schemas.microsoft.com/office/drawing/2014/chartex`" xmlns:cx1=`"http://schemas.microsoft.com/office/drawing/2015/9/8/chartex`" xmlns:cx2=`"http://schemas.microsoft.com/office/drawing/2015/10/21/chartex`" xmlns:cx3=`"http://schemas.microsoft.com/office/drawing/2016/5/9/chartex`" xmlns:cx4=`"http://schemas.microsoft.com/office/drawing/2016/5/10/chartex`" xmlns:cx5=`"http://schemas.microsoft.com/office/drawing/2016/5/11/chartex`" xmlns:cx6=`"http://schemas.microsoft.com/office/drawing/2016/5/12/chartex`" xmlns:cx7=`"http://schemas.microsoft.com/office/drawing/2016/5/13/chartex`" xmlns:cx8=`"http://schemas.microsoft.com/office/drawing/2016/5/14/chartex`" xmlns:mc=`"http://schemas.openxmlformats.org/markup-compatibility/2006`" xmlns:aink=`"http://schemas.microsoft.com/office/drawing/2016/ink`" xmlns:am3d=`"http://schemas.microsoft.com/office/drawing/2017/model3d`" xmlns:o=`"urn:schemas-microsoft-com:office:office`" xmlns:oel=`"http://schemas.microsoft.com/office/2019/extlst`" xmlns:r=`"http://schemas.openxmlformats.org/officeDocument/2006/relationships`" xmlns:m=`"http://schemas.openxmlformats.org/officeDocument/2006/math`" xmlns:v=`"urn:schemas-microsoft-com:vml`" xmlns:wp14=`"http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing`" xmlns:wp=`"http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing`" xmlns:w10=`"urn:schemas-microsoft-com:office:word`" xmlns:w=`"http://schemas.openxmlformats.org/wordprocessingml/2006/main`" xmlns:w14=`"http://schemas.microsoft.com/office/word/2010/wordml`" xmlns:w15=`"http://schemas.microsoft.com/office/word/2012/wordml`" xmlns:w16cex=`"http://schemas.microsoft.com/office/word/2018/wordml/cex`" xmlns:w16cid=`"http://schemas.microsoft.com/office/word/2016/wordml/cid`" xmlns:w16=`"http://schemas.microsoft.com/office/word/2018/wordml`" xmlns:w16du=`"http://schemas.microsoft.com/office/word/2023/wordml/word16du`" xmlns:w16sdtdh=`"http://schemas.microsoft.com/office/word/2020/wordml/sdtdatahash`" xmlns:w16se=`"http://schemas.microsoft.com/office/word/2015/wordml/symex`" xmlns:wpg=`"http://schemas.microsoft.com/office/word/2010/wordprocessingGroup`" xmlns:wpi=`"http://schemas.microsoft.com/office/word/2010/wordprocessingInk`" xmlns:wne=`"http://schemas.microsoft.com/office/word/2006/wordml`" xmlns:wps=`"http://schemas.microsoft.com/office/word/2010/wordprocessingShape`" mc:Ignorable=`"w14 w15 w16se w16cid w16 w16cex w16sdtdh w16du wp14`"><w:body>$bodyXml</w:body></w:document>"

Set-Content -LiteralPath $documentPath -Value $newXml -Encoding UTF8

$newZip = Join-Path ([System.IO.Path]::GetTempPath()) ("expanded-report-" + [guid]::NewGuid().ToString() + ".docx")
if (Test-Path -LiteralPath $newZip) { Remove-Item -LiteralPath $newZip -Force }
[System.IO.Compression.ZipFile]::CreateFromDirectory($tempRoot, $newZip)
Move-Item -LiteralPath $newZip -Destination $TargetPath -Force

Write-Output $TargetPath



