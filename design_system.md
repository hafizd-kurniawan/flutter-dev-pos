# POS Resto App - Design System

## 1. Typography (Google Fonts: Quicksand)
Consistent font usage is key to a professional look. We use Quicksand for a modern, friendly feel.

| Style | Size | Weight | Color | Usage |
|---|---|---|---|---|
| **H1 (Page Title)** | 24px | Bold (700) | Primary (#3949AB) | Main Page Headers (e.g., "Menu", "History") |
| **H2 (Section)** | 20px | SemiBold (600) | Black (#000000) | Section Headers (e.g., "Categories", "Order Summary") |
| **H3 (Card Title)** | 16px | Bold (700) | Black (#000000) | Product Names, Table Names |
| **Body (Normal)** | 14px | Medium (500) | Grey (#666666) | Product Descriptions, Order Items |
| **Caption (Hint)** | 12px | Regular (400) | Grey (#999999) | Subtitles, Hints, Timestamps |
| **Button Text** | 14px | Bold (700) | White (#FFFFFF) | Primary Actions |

## 2. Colors
| Name | Hex | Usage |
|---|---|---|
| **Primary** | `#3949AB` | Brand color, Active states, Primary Buttons |
| **Background** | `#F8F5FF` | App Background (Light Grey/Purple tint) |
| **Surface** | `#FFFFFF` | Cards, Headers, Dialogs |
| **Success** | `#50C474` | Completed status, Success toasts |
| **Error** | `#F4261A` | Error states, Delete actions |
| **Text Primary** | `#000000` | Main text |
| **Text Secondary** | `#B7B7B7` | Secondary text, Placeholders |

## 3. Spacing & Layout
We use a 4px grid system.

*   **XS**: 4px
*   **S**: 8px
*   **M**: 16px
*   **L**: 24px
*   **XL**: 32px
*   **XXL**: 100px (Top Padding for Floating Header pages)

## 4. Components & Layout Strategy

### Unified Floating Header (Best Practice Analysis)
**Problem**: On mobile, displaying Title + Search Bar + Actions causes overflow ("kepangkas").
**Solution**: Adaptive Layout based on screen width.

| Element | Desktop (> 900px) | Tablet (600-900px) | Mobile (< 600px) |
|---|---|---|---|
| **Container** | Width: Fit Content (Max 80%) | Width: Fit Content | Width: Stretch (Margin 16px) |
| **Title** | Visible (Full) | Visible (Full) | Visible (Truncated) or Hidden when searching |
| **Search** | Wide Bar (300px) | Medium Bar (200px) | Icon Only (Expands on tap) OR Mini Bar (120px) |
| **Actions** | Visible | Visible | Visible |

**Proposed Mobile Layout**: `[Menu] [Title (Flex)] [Search Icon] [Refresh]`
**Reasoning**: Keeps the UI clean. Tapping "Search" can expand a bar that temporarily covers the title, ensuring full functionality without clutter.

### Mobile Header Layout Options (Analysis)
The user requested a "Centered" look for mobile. Here are the possibilities:

*   **Option A: Classic Center (iOS Style) (SELECTED)**
    *   Layout: `[Menu] [Title (Center)] [Actions]`
    *   Precision: Title is centered relative to the screen width.
    *   Pros: Familiar, balanced, professional.
    *   Cons: Title width is limited by the wider of the two side blocks (usually Actions). Long titles truncate early.

### Sidebar & Overflow Strategy
**Problem**: When Sidebar expands (Desktop), content often overflows or gets cut off.
**Solution**:
*   **Desktop**: Use `Row > [Sidebar, Expanded(Content)]`. The Content MUST be wrapped in Expanded to shrink dynamically.
*   **Mobile**: Sidebar is an Overlay (Drawer or Stack overlay). Content does not shrink.
*   **Grid Responsiveness**: `SliverGridDelegateWithMaxCrossAxisExtent` or dynamic `crossAxisCount` based on current width (`LayoutBuilder`), not screen width.

### Global Margins (Professional Look)
*   **Page Margin**: `EdgeInsets.symmetric(horizontal: 24.0)` for all main content.
*   **Top Padding**: `100.0` (Fixed for Floating Header).
*   **Bottom Padding**: `24.0` (Safe area).

### Product Card (Clean & Elegant)
*   **Style**: "Card" look with white background and soft shadow.
*   **Image**: Full width, aspect ratio 1:1, rounded top corners.
*   **Typography**:
    *   Name: H3 (16px Bold) - Max 2 lines.
    *   Price: Body (14px Bold Primary Color).
    *   Stock: Caption (12px Grey).

### Category Tabs
*   **Style**: Pill shape.
*   **Interaction**: Smooth transition on tap.
*   **Active**: Primary Color Background, White Text.
*   **Inactive**: Grey Outline, Grey Text.

### Cart Section
*   **Background**: White (#FFFFFF)
*   **Border Radius**: 16.0
*   **Shadow**: `Color(0x0D000000)`, Blur 10, Offset 0, 4
*   **Margin**: 16.0 (Right/Bottom)

## 5. Page Layout Standards

### Standard Page Structure
All main pages (`HomePage`, `HistoryPage`, `SettingsPage`, etc.) must follow this structure to ensure the Floating Header works correctly:

```dart
Scaffold(
  body: Stack(
    children: [
      // 1. Main Content
      Padding(
        padding: EdgeInsets.only(top: 100.0), // Space for Header
        child: BodyContent(),
      ),
      
      // 2. Floating Header (Always on top)
      Positioned(
        top: 0, left: 0, right: 0, // Stretch width
        child: FloatingHeader(...),
      ),
    ],
  ),
)
```

### Header Variants
*   **Main Header (Burger Menu)**: Used for top-level pages (Home, History, Settings).
*   **Sub-Page Header (Back Arrow)**: Used for detail pages (Confirm Payment, Add Table).
    *   Action: Replaces Burger Menu with Back Button (`Navigator.pop`).

### Sidebar & Responsiveness
*   **Sidebar Open**: Content pushes or shrinks (Desktop) / Overlay (Mobile).
*   **Sidebar Closed**: Content expands.
*   **Floating Header**: Always stays fixed at the top, width adjusts if Sidebar pushes it (or it overlays).
*   **Current Implementation**: Header is inside the main content area, so it moves with the content. This is acceptable.

## 6. Page-Specific Analysis & Plan

| Page | Current Status | Action Required |
|---|---|---|
| **HomePage** | Good. Uses Floating Header. | Refine Cart section consistency. |
| **HistoryPage** | Good. Uses Floating Header. | Ensure list items match Card style. |
| **TableManagement** | Good. Uses Floating Header. | Ensure grid items match Card style. |
| **SettingsPage** | Incomplete. Missing Header. | Refactor: Add Stack + FloatingHeader. |
| **PrinterConfig** | Incomplete. Missing Header. | Refactor: Add Stack + FloatingHeader. |
| **ConfirmPayment** | Inconsistent. Custom Header. | Refactor: Use FloatingHeader (Back Variant). |
| **LoginPage** | Good. Standalone. | No change needed. |
