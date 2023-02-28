const express = require("express");
const app = express();
const cors = require("cors");
const pool= require("./db");

//middleware
app.use(cors());
app.use(express.json());

//ROUTES

//create a hotelchain
app.post("/Hotel_Chain", async(req,res) =>{
    try{
        
        const { arg1,arg2,arg3,arg4,arg5,arg6,arg7} = req.body;
        console.log(req.body);
        const newHotelChain = await pool.query(
            "INSERT INTO hotel_chain (chainname,country,postal_code,address,phonenumber,email,region) VALUES($1,$2,$3,$4,$5,$6,$7)", 
            [arg1,arg2,arg3,arg4,arg5,arg6,arg7]
        );
        res.json(newHotelChain);
    } catch(err) {
        console.error(err.message);
    }
}) 
app.listen(5000, () => {
    console.log("server has started on port 5000");
});