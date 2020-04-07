const faker = require('faker');
const fs = require('fs-extra');

Array.prototype.sample = function(){
    return this[Math.floor(Math.random()*this.length)];
}

let out = ''

let num_users = 100;
let locations_per_user = 2;
let num_drivers = 10;
let num_resturants = 10;
let max_orders_per_user = 3;

out += '\n\n\n-- DELETING ALL DATA\n'
out += 'SET SQL_SAFE_UPDATES = 0;\n'
out += 'DELETE FROM vehicles;\n'
out += 'DELETE FROM drivers;\n'
out += 'DELETE FROM users;\n'

out += '\n\n\n-- GENERATING USERS\n'
out += 'ALTER TABLE users AUTO_INCREMENT = 1;\n'
for(let i = 0; i < num_users; i++) {
    out += faker.fake(`INSERT INTO users (first_name, last_name, email, phone) VALUES ('${faker.name.firstName().replace(/'/g, '')}', '${faker.name.lastName().replace(/'/g, '')}', '{{internet.email}}', '{{phone.phoneNumber}}');\n`)
}

let drivers = []
out += '\n\n\n-- GENERATING DRIVERS\n'
for(let i = 0; i < num_drivers; i++) {
    let driver_id = Math.ceil(Math.random() * num_users)
    drivers.push(driver_id)
    out += faker.fake(`INSERT INTO drivers (id, license_no, approved, is_working) VALUES (${driver_id}, '${faker.random.number(100000,999999)}', 1, 1);\n`)
}


out += '\n\n\n-- GENERATING VEHICLES\n'
for(let d_id of drivers) {
    out += faker.fake(`INSERT INTO vehicles (driver_id, color, model, year) VALUES (${d_id}, '${faker.commerce.color()}', '{{random.alphaNumeric(10)}}', '${faker.finance.amount(1950, 2020, 0)}');\n`)
}


out += '\n\n\n-- GENERATING LOCATIONS\n'
for(let i = 0; i < num_users; i++) {
    for(let j = 0; j < locations_per_user; j++)
        out += faker.fake(`INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('${faker.company.companyName().replace(/'/g, '')}', '${faker.address.streetAddress().replace(/'/g, '')}','{{address.secondaryAddress}}','${faker.address.city().replace(/'/g, '')}','{{address.stateAbbr}}','{{address.zipCode}}',{{address.latitude}},{{address.longitude}},'{{lorem.words(10)}}','${i+1}');\n`)
}

out += '\n\n\n-- GENERATING RESTAURANTS\n'
out += 'ALTER TABLE restaurants AUTO_INCREMENT = 1;\n'
for(let i = 0 ; i < num_resturants; i++) {
    out += faker.fake(`INSERT INTO restaurants (name, website, fee, open_time, close_time, approved) VALUES ('${faker.company.companyName().replace(/'/g, '')}', '{{internet.domainName}}', ${faker.finance.amount(1, 10, 2)}, '2020-1-1 08:00:00', '2020-1-1 20:00:00', 1);\n`)
}


out += '\n\n\n-- GENERATING ORDERS\n'
for(let i = 0 ; i < num_users; i++) {
    for(let j = 0; j < Math.floor(Math.random() * (max_orders_per_user + 1)); j++)
        out += faker.fake(`INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (${(i + 1)}, ${drivers.sample()}, ${faker.finance.amount(1, num_resturants, 0)}, ${faker.finance.amount(1, locations_per_user * num_users, 0)}, '{{lorem.words(20)}}', '${faker.date.recent().toISOString().replace('T', ' ').replace('Z', '')}', ${faker.finance.amount(5, 50, 2)});\n`)
}

fs.outputFileSync('./data.sql', out)