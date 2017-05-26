#include <iostream>
#include <sstream>
#include <memory>
#include <map>
#include <vector>

struct Item
{
	public:
	std::string id;
	std::string name;
	double price;

	Item(const std::string& id, const std::string& name, double price) : id(id), name(name), price(price) {}

	//just to be able to put it in a map
	bool operator<(const Item& b) const
	{
		return price < b.price;
	}
	friend std::ostream& operator<<(std::ostream& out, const Item& item);
};

std::ostream& operator<<(std::ostream& out, const Item& item)
{
	return out << '[' << item.id << "] " << item.name << " (" << item.price << " $)";
}

//indexing the tours by their respective IDs
const std::map<std::string, Item> tours {
	{"OH", Item("OH", "Opera House Tour", 300.0)},
	{"BC", Item("BC", "Syndney Bridge Climb", 110.0)},
	{"SK", Item("SK", "Syndney Sky Tower", 30.0)},
};

class Rule
{
	public:
	virtual std::map<Item, int> applyDiscount(std::map<Item, int> items) = 0;
};

class FreeSkyTourRule : public Rule
{
	std::map<Item, int> applyDiscount(std::map<Item, int> items)
	{
		auto oh = items.find(tours.at("OH"));
		if(oh == items.end())
			return items;
		auto sk = items.find(tours.at("SK"));
		if(sk == items.end())
			return items;
		Item discount("DC", "Free Sky Discount", -sk->first.price);
		items[discount] = sk->second > oh->second ? oh->second : sk->second;
		return items;
	}
};

class ThreeForTwoRule : public Rule
{
	std::map<Item, int> applyDiscount(std::map<Item, int> items)
	{
		auto oh = items.find(tours.at("OH"));
		if(oh == items.end())
			return items;
		int quantity = oh->second;
		Item discount("DC", "Opera House Discount", -oh->first.price);
		if(quantity > 2)
			items[discount] = oh->second / 3;
		return items;
	}
};

class BridgeClimbDiscountRule : public Rule
{
	std::map<Item, int> applyDiscount(std::map<Item, int> items)
	{
		auto bc = items.find(tours.at("BC"));
		if(bc == items.end())
			return items;
		int quantity = bc->second;
		if(quantity > 4)
		{
			Item discount("DC", "Bridge Climb Discount", -20.0);
			items[discount] = quantity;
		}
		return items;
	}
};

class ShoppingCart
{
	private:
	std::map<Item, int> items;
	std::vector<std::unique_ptr<Rule>> rules;

	public:
	void addItem(Item item)
	{
		items[item]++;
	}

	void addRule(std::unique_ptr<Rule> rule)
	{
		rules.push_back(std::move(rule));
	}

	std::map<Item, int> getBill() const
	{
		std::map<Item, int> bill = items;
		for(auto& rule: rules)
			bill = rule->applyDiscount(bill);
		return bill;
	}

	double total(const std::map<Item, int>& bill) const
	{
		double sum = 0;
		for(auto& kv: bill)
			sum += kv.first.price * kv.second;
		return sum;
	}

	double total() const
	{
		return total(getBill());
	}
};

int main()
{
	std::string line;
	while(getline(std::cin, line))
	{
		std::string entry;
		std::stringstream ss(line);
		ShoppingCart cart;
		while(ss >> entry)
		{
			cart.addItem(tours.at(entry));
		}
		cart.addRule(std::unique_ptr<Rule>(new BridgeClimbDiscountRule));
		cart.addRule(std::unique_ptr<Rule>(new ThreeForTwoRule));
		cart.addRule(std::unique_ptr<Rule>(new FreeSkyTourRule));
		std::cout << line << std::endl;
		auto bill = cart.getBill();
		for(auto& kv: bill)
			std::cout << "\tx" << kv.second << " : " << kv.first << std::endl;
		std::cout << "\tTotal in $ : " << cart.total(bill) << std::endl;
		std::cout << std::endl;
	}
	return 0;
}
