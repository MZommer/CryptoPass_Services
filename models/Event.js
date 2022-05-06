const { Schema, model } = require("mongoose");

const Event = new Schema({
    EventID: {
        type: String,
        required: true,
        unique: true,
    },
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
    // Assets
    IsActive: {
        type: Boolean,
        required: true,
    },
    IsPublic: {
        type: Boolean,
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