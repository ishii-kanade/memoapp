# MemoApp

A new Flutter project built with Clean Architecture in mind. This project demonstrates how to structure a Flutter application using clear separation of concerns, making it maintainable, testable, and extensible.

## Overview

MemoApp leverages Clean Architecture to divide the codebase into distinct layers:

- **Domain Layer:** Contains business logic, including entities and use cases.
- **Data Layer:** Handles data-related operations such as JSON parsing, file I/O, and interactions with external APIs or local storage.
- **Presentation Layer:** Manages UI components, state management, and user interactions.

This approach allows each layer to focus on its core responsibilities, ensuring that changes in one layer have minimal impact on the others. It also makes the application easier to test, as you can mock dependencies and verify business logic independently from the UI and data layers.

## Project Structure

Here's a brief overview of the project structure:

```
/lib
  ├─ /data         # Data layer: repositories, data sources, and models
  ├─ /domain       # Domain layer: business logic, entities, use cases, and repository abstractions
  └─ /presentation # Presentation layer: UI components, state management, and pages
```

By following Clean Architecture principles, MemoApp remains organized and easily adaptable to future changes.

## License

This project is open source and available under the MIT License.