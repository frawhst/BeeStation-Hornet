/datum/symptom/beesease
	name = "Bee Infestation"
	desc = "Causes the host to cough toxin bees and occasionally synthesize toxin."
	stealth = -2
	resistance = 2
	stage_speed = 1
	transmittable = 1
	level = 9
if(honey)
 	severity = 0
else if(toxic_bees)
 	severity = 5
else
 	severity = 4
	symptom_delay_min = 5
	symptom_delay_max = 20
	var/honey = FALSE
	var/infected_bees = FALSE
	threshold_desc = "<b>Resistance 14:</b> Host synthesizes honey instead of toxins, bees now sting with honey instead of toxin.<br>\
					  <b>Transmission 10:</b> Bees now contain a completely random toxin, unless resistance exceeds 14"		
					  
/datum/symptom/beesease/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["resistance"] >= 14)
		honey = TRUE
	if(A.properties["transmission"] >= 10)
		toxic_bees = TRUE

/datum/symptom/beesease/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	switch(A.stage)
		if(2)
			if(prob(2))
				to_chat(M, "<span class='notice'>You taste honey in your mouth.</span>")
		if(3)
			if(prob(15))
				to_chat(M, "<span class='notice'>Your stomach tingles.</span>")
			if(prob(15))
				if(honey)
					to_chat(M, "<span class='notice'>You can't get the taste of honey out of your mouth!.</span>")
					M.reagents.add_reagent(/datum/reagent/consumable/honey, 2)
				else
					to_chat(M, "<span class='danger'>Your stomach stings painfully.</span>")				
					M.adjustToxLoss(5)
					M.updatehealth()
		if(4, 5)
			if(prob(15))
				to_chat(M, "<span class='notice'>Your stomach squirms.</span>")
			if(prob(15))
				if(honey)
					to_chat(M, "<span class='notice'>You can't get the taste of honey out of your mouth!.</span>")
					M.reagents.add_reagent(/datum/reagent/consumable/honey, 3)
				else
					to_chat(M, "<span class='danger'>Your stomach stings painfully.</span>")				
					M.adjustToxLoss(5)
					M.updatehealth()
			if(prob(10))
				M.visible_message("<span class='danger'>[M] buzzes.</span>", \
								  "<span class='userdanger'>Your stomach buzzes violently!</span>")
			if(prob(15))
				to_chat(M, "<span class='danger'>You feel something moving in your throat.</span>")
			if(prob(10))
				M.visible_message("<span class='danger'>[M] coughs up a bee!</span>", \
								  "<span class='userdanger'>You cough up a bee!</span>")
				if(honey)
					var/mob/living/simple_animal/hostile/poison/bees/toxin/B = new(M.loc)
					B.assign_reagent(/datum/reagent/consumable/honey)
				else if(toxic_bees)
					new /mob/living/simple_animal/hostile/poison/bees/toxin(M.loc)
				else
					new /mob/living/simple_animal/hostile/poison/bees(M.loc)
