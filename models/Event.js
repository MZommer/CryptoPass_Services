const { Schema, model } = require("mongoose");

const EventSchema = new Schema({
    UserID: {
        type: String,
        required: true,
    },
    Title: {
        type: String,
        required: true,
        trim: true,
    },
    Description: {
        type: String,
        required: true,
        trim: true,
    },
    Location: {
        type: String,
        required: true,
    },
    Date: {
        type: Date,
        required: true,
    },
    ReleaseDate: {
        type: Date,
        required: true,
    },
    // Assets
    IsActive: {
        type: Boolean,
        required: true,
    },
    IsPublic: {
        type: Boolean,
        required: true,
    },
    TicketAmount: {
        type: Number,
        requiered: true,
    },
    Tickets: {
        type: Array,
        required: true,
    },
    TicketTypes: {
        type: Array,
        required: true,
    },
    Genres: {
        type: Array,
        required: true,
    },
    Tags: {
        type: Array,
        required: true,
    },
    MinAge: {
        type: Number,
        required: true,
    },
},
{
    timestamps: true,
    versionKey: false,
})

module.exports = model("Event", EventSchema);