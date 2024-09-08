<h1>AssetRegistry App</h1>

<p><strong>AssetRegistry</strong> is an Android application designed to manage and track a company's assets, ranging from furniture and electronics to office supplies. The app provides functionalities for adding, updating, deleting, and viewing assets, employees, locations, and inventory lists.</p>

<h2>Features</h2>

<h3>1. Asset Management</h3>
<ul>
    <li><strong>Attributes</strong>: Each asset has the following attributes: name, description, barcode (integer), price, creation date, assigned person (employee), assigned location (city), and image.</li>
    <li><strong>CRUD Operations</strong>: The app supports Create, Read, Update, and Delete operations for assets.</li>
    <li><strong>Barcode Input</strong>: Barcode values can be entered manually or scanned using the device's camera. The barcode scanning functionality is implemented using external libraries.</li>
    <li><strong>Image Upload</strong>: Images can be uploaded from the device or captured using the device's camera.</li>
</ul>

<h3>2. Category Views</h3>
<ul>
    <li><strong>Lists</strong>: Display lists of assets, employees, locations, and inventory lists.</li>
    <li><strong>Search Functionality</strong>: Search items in each list based on at least two criteria.</li>
</ul>

<h3>3. Inventory Lists</h3>
<ul>
    <li><strong>Creation</strong>: Create inventory lists containing multiple items.</li>
    <li><strong>Attributes</strong>: Each item in the list includes the asset, the current person responsible for the asset, the new person to whom the asset is assigned, the current location of the asset, and the new location of the asset.</li>
    <li><strong>Barcode Scanning</strong>: During the creation of a new item, scan the barcode of the asset to automatically fill in other related data (e.g., name, assigned person, assigned location).</li>
</ul>

<h3>4. Asset Details</h3>
<ul>
    <li><strong>Details View</strong>: View detailed information about each asset, including basic details and an image.</li>
    <li><strong>Map View</strong>: View the asset's location on a map with a pin indicating the city. Clicking on the pin displays a list of all assets currently in that city.</li>
</ul>

<h3>5. Language Settings</h3>
<ul>
    <li><strong>Language Selection</strong>: Choose between Serbian and English languages in the settings page.</li>
</ul>

<h3>6. Asynchronous Operations</h3>
<ul>
    <li><strong>Tasks</strong>: Operations that might block the main thread are handled asynchronously, ensuring a smooth and responsive user experience.</li>
</ul>

<h2>Usage</h2>

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
            <li>Navigate to the settings page to change the application language or theme.</li>
        </ul>
    </li>
</ol>
