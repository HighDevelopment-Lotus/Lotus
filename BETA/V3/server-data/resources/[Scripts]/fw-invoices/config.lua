Config = {}

-------------------------- COMMANDS & FUNCTIONALITY

Config.InvoicesCommand = 'factuur' -- Command used to open the invoices menu

Config.VATPercentage = 6 -- Visual only, it won't influence the final invoice value, change it to your country VAT value

Config.LimitDate = true -- Used to enable/disable whether we want to have the payment limit date or not

Config.LimitDateDays = 2 -- If Config.LimitDate is enabled, it is used to define the days of the deadline for payment after issuing the invoice

Config.PayAutomaticallyAfterLimit = true -- It serves to enable/disable if we want the invoice to be automatically paid after the due date

-- (For this to work you need to set  = true and add a number to LimitDateDays)
Config.FeeAfterEachDay = false -- Serves to enable/disable if we want unpaid invoices to increase in value after each day they are not paid 

Config.FeeAfterEachDayPercentage = 5 -- If Config.FeeAfterEachDay is enabled, it is used to set the fee percentage after each day

Config.OnlyBossCanAccessSocietyInvoices = false -- Defines if only the boss can access the society invoices, if false all the employees will have access to it

Config.AllowedSocieties = { -- Allowed societies to open the 'Society Invoices' and 'Create Invoice' menus
	'police',
	'ambulance',
	'mechanic',
	'vanilla',
	'realestate',
}

-------------------------- DISCORD LOGS

-- To set your Discord Webhook URL go to server.lua, line 5

Config.BotName = 'Factuur Bot' -- Write the desired bot name

Config.ServerName = 'PEPE' -- Write your server's name

Config.IconURL = '' -- Insert your desired image link

Config.DateFormat = '%d/%m/%Y [%X]' -- To change the date format check this website - https://www.lua.org/pil/22.1.html

-- To change a webhook color you need to set the decimal value of a color, you can use this website to do that - https://www.mathsisfun.com/hexadecimal-decimal-colors.html45518a

Config.CreateNewInvoiceWebhookColor = '16127'

Config.PayInvoiceWebhookColor = '65352'

Config.AutopayInvoiceWebhookColor = '4542858'

Config.CancelInvoiceWebhookColor = '9868950'