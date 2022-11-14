const { expect, assert } = require("chai");
const hre = require("hardhat");
const { time, loadFixture, } = require("@nomicfoundation/hardhat-network-helpers");

const dateNow = () => Math.round(Date.now()/1000)

const placeholderEventInfo = {
    Title: "Dummy",
    Description: "TBA",
    Location: "TBA",
    Date: dateNow() + 60000,
    ReleaseDate: dateNow(),
    IsActive: true,
    IsPublic: true,
    TicketAmount: 0xffff,
    MinAge: 18,
}

async function deploy(eventInfo) {
    var eventInfo = eventInfo || placeholderEventInfo;

    const SaleLib = await hre.ethers.getContractFactory("SaleLib");
    const saleLib = await SaleLib.deploy();
    await saleLib.deployed();

    const Event = await hre.ethers.getContractFactory("Event", {
        libraries: {
            SaleLib: saleLib.address,
        }
    });
    const event = await Event.deploy(...Object.values(eventInfo));
    await event.deployed();
    return event;
}

describe("Event", () => {
    // If it deploys
    // check get the struct with the event data
    // check mint
    // check mint if is not active, 
    // if is not release date yet,
    // if is not public,
    // check sale suply limit
    // check max mint per account and per tx


    // check mark ticket function
    // get account tokens


    it("Deploy", async () => {
        const event = await deploy(placeholderEventInfo);
        const eventInfo = await event.eventInfo();
        expect(eventInfo.ReleaseDate).to.equal(placeholderEventInfo.ReleaseDate)//, "Deploy error, release date is not the expected")
    });
    it("Creates a sale", async () => {
        const event = await deploy();

        await event.createSale(
            dateNow() + 500,
            dateNow() + 500,
            10,
            15,
            5,
            10,
            200
        );
        await time.increaseTo((await time.latest()) + 1000) // fast forward to when the sale starts
        const salePrice = await event.getSalePrice(0);

        expect(salePrice).to.equal(15);

    })
    it("Mints", async () => {
        const event = await deploy();
        await event.createSale(
            dateNow() + 5000,
            dateNow() + 5000,
            10,
            15,
            5,
            10,
            200
        );
        await time.increaseTo((await time.latest()) + 10000) // fast forward to when the sale starts
        const [owner] = await hre.ethers.getSigners();

        await event.mint(0, owner.address, 2, { value: 30 });

        const balance = await event.balanceOf(owner.address);

        expect(balance).to.equal(2);
    });

    it("Gets address Tokens", async () => {
        const event = await deploy();
        await event.createSale(
            dateNow() + 5000,
            dateNow() + 5000,
            10,
            15,
            5,
            10,
            200
        );
        await time.increaseTo((await time.latest()) + 10000) // fast forward to when the sale starts
        const [owner] = await hre.ethers.getSigners();

        await event.mint(0, owner.address, 2, { value: 30 });
        const addressTokens = await event.getAddressTokens(owner.address);
        console.log(addressTokens)
    })


})
