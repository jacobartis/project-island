extends Resource
class_name FishingTable

@export var fish:Array[FishData] = []
##Lowers the disribution curve of fish, should be around 2 by default
@export var base_quality_bonus:float = 2.5

#SoftMax to generate distribution
func get_precentages(bonus:float=0):
	var logits = []
	var total:float = 0
	for x in fish.size():
		var logit = exp(-float(fish[x].rarity)/(base_quality_bonus+bonus))
		logits.append(logit)
		total += logit
	var perc = []
	for logit in logits:
		perc.append(logit/total)
	return perc

func get_fish(bonus:float=0):
	var perc = get_precentages(bonus)
	var rand = randf()
	var index = 0
	for x in perc:
		rand -= x
		if rand <= 0:
			return fish[index]
		index += 1
	return fish[0]

func test():
	var res = []
	var throws = 1000
	for x in throws:
		res.append(get_fish().rarity)
	print("Caught in {x} throws".format({"x":throws}))
	print("Commons {n}".format({"n":res.count(0)}))
	print("Unommons {n}".format({"n":res.count(1)}))
	print("Rares {n}".format({"n":res.count(2)}))
	print("Epics {n}".format({"n":res.count(3)}))
	print("Legendary {n}".format({"n":res.count(4)}))
	print("Mythic {n}".format({"n":res.count(5)}))
