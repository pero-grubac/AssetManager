# AssetRegistry App

AssetRegistry is an Android application designed to manage and keep track of a company's assets. These assets can range from furniture and electronics to office supplies. The app provides functionalities for adding, updating, deleting, and viewing assets, employees, locations, and inventory lists.

## Features

### 1. <font size="5">Asset Management</font>
<ul>
    <li><strong>Attributes</strong>: Each asset (OS) has the following attributes: name, description, barcode (integer), price, creation date, assigned person (employee), assigned location (city), and image.</li>
    <li><strong>CRUD Operations</strong>: Create, read, update, and delete operations are supported for assets.</li>
    <li><strong>Barcode Input</strong>: Barcode value can be entered manually or by scanning using the device's camera. The barcode scanning functionality is implemented using external libraries (e.g., ZXing).</li>
    <li><strong>Image Upload</strong>: Images can be uploaded from the device or captured using the device's camera.</li>
</ul>

### 2. <font size="5">Category Views</font>
<ul>
    <li><strong>Lists</strong>: Display lists of assets, employees, locations, and inventory lists.</li>
    <li><strong>Search Functionality</strong>: Search items in each list based on at least two criteria.</li>
</ul>

### 3. <font size="5">Inventory Lists</font>
<ul>
    <li><strong>Creation</strong>: Create inventory lists containing multiple items.</li>
    <li><strong>Attributes</strong>: Each item in the list includes the asset, the current person responsible for the asset, the new person to whom the asset is assigned, the current location of the asset, and the new location of the asset.</li>
    <li><strong>Barcode Scanning</strong>: During the creation of a new item, scan the barcode of the asset to automatically fill in other related data (name, assigned person, assigned location, etc.).</li>
</ul>

### 4. <font size="5">Asset Details</font>
<ul>
    <li><strong>Details View</strong>: View detailed information about each asset, including basic details, image, currently assigned person, and location.</li>
    <li><strong>Map View</strong>: View the location on a map with a pin indicating the city. Clicking on the pin displays a list of all assets currently in that city.</li>
</ul>

### 5. <font size="5">Language Settings</font>
<ul>
    <li><strong>Language Selection</strong>: Choose between Serbian and English languages in the settings page.</li>
</ul>

### 6. <font size="5">Asynchronous Operations</font>
<ul>
    <li><strong>AsyncTask</strong>: Use <code>AsyncTask</code> or suitable libraries to handle operations that might block the main thread, ensuring smooth and responsive user experience.</li>
</ul>

### 7. <font size="5">Graphic Elements</font>
<ul>
    <li><strong>Screen Densities</strong>: Generate graphic elements to cover various screen densities and dimensions.</li>
    <li><strong>Vector Graphics</strong>: Use vector graphics wherever possible to maintain performance.</li>
    <li><strong>Performance Considerations</strong>: Ensure efficient layout management and view rendering to optimize performance.</li>
    <li><strong>Design</strong>: Follow the latest design trends and guidelines, such as Material Design, to create a minimalist and visually appealing user interface.</li>
    <li><strong>Styles and Themes</strong>: Define styles and themes separately to achieve flexibility and modularity in the code.</li>
</ul>


## Usage

<ol>
    <li><strong>Assets Management</strong>:
        <ul>
            <li>Add new assets by clicking the "Add Asset" button.</li>
            <li>Fill in the required details, scan the barcode, and upload or capture an image.</li>
            <li>Save the asset to add it to the list.</li>
            <li>Edit or delete assets by selecting them from the list.</li>
        </ul>
    </li>
    <li><strong>Employees and Locations</strong>:
        <ul>
            <li>Manage employees and locations similarly by adding, editing, or deleting entries.</li>
            <li>Use the search functionality to find specific employees or locations.</li>
        </ul>
    </li>
    <li><strong>Inventory Lists</strong>:
        <ul>
            <li>Create inventory lists and add items by scanning asset barcodes.</li>
            <li>Ensure all required details are filled in for each item in the list.</li>
        </ul>
    </li>
    <li><strong>Settings</strong>:
        <ul>
            <li>Navigate to the settings page to change the application language.</li>
        </ul>
    </li>
</ol>


