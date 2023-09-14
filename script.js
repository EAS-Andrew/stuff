const puppeteer = require('puppeteer');
const cron = require('node-cron');
const nodemailer = require('nodemailer');

var transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: 'apwilliams508@gmail.com',
        pass: ''
    }
});

const logic = async () => {
    // Launch the browser and open a new blank page
    const browser = await puppeteer.launch();
    const page = await browser.newPage();

    await page.goto('https://www.dyfibikepark.co.uk/product/uplift/')

    await page.waitForSelector('.blockOverlay');
    await page.waitForSelector('.blockOverlay', { hidden: true });

    let v = await page.$eval(".picker > div > table > tbody > tr:nth-child(5) > td:nth-child(6)", element => ({ class: element.getAttribute("class"), innerHTML: element.children[0].innerHTML }))

    if (!v.class.includes('fully_booked')) {
        console.log(`can book ${v.innerHTML}`)
        var mailOptions = {
            from: 'apwilliams508@gmail.com',
            to: 'apwilliams508@gmail.com',
            subject: 'BOOK DYFI BITCH',
            text: 'https://www.dyfibikepark.co.uk/product/uplift/'
        };
        transporter.sendMail(mailOptions, function (error, info) {
            if (error) {
                console.log(error);
            } else {
                console.log('Email sent: ' + info.response);
            }
        });
    } else {
        console.log(`can't book ${v.innerHTML}`)
    }

    await browser.close();
}


cron.schedule('* * * * *', logic)
