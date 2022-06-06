//
//  ExtraUtil.swift
//  TargetedCoupon
//
//  Created by Muhammad Ahsan on 29/11/2020.
//

import UIKit

func loadCoupons(successfulHandler:@escaping (Coupons?, Error?) -> ()) {
    if let path = Bundle.main.path(forResource: "coupon", ofType: "json") {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let menu: Coupons = try JSONDecoder().decode(Coupons.self, from: data)
            successfulHandler(menu, nil)
        } catch let error {
            successfulHandler(nil, error)
        }
    }
}

func checkCoupon(coupon: Coupon) -> Bool {
    var conditions: [String] = []
    for (conditionIndex, condition) in coupon.data!.enumerated() {
        //print(condition.condition)
        let conditionComponents = condition.condition.components(separatedBy: " ")
        for (index, component) in conditionComponents.enumerated() {
            var variable = getVariable(value: component)
            if variable.last == "," {
                variable.removeLast()
                conditions.append(variable)
                conditions.append("AND")
            } else if variable == "between" {
                conditions.append(">=")
            } else if index > 2 && conditionComponents.count > 3 && conditionComponents[index-2] == "between" {
                conditions.append(conditions[conditions.count-4])
                conditions.append("<=")
                conditions.append(variable)
            } else {
                conditions.append(variable)
            }
        }
        if conditionIndex + 1 != coupon.data?.count {
            conditions.append(condition.op)
        }
    }
    print(conditions)
    return calculateConditions(conditions: conditions)
}

func calculateConditions(conditions: [String]) -> Bool {
    var resultArray: [Any] = []
    var conditionsArray = conditions
    while conditionsArray.count != 0 {
        if conditions.count > 0 {
            let result = evaluateExpression(conditions: &conditionsArray)
            print(result)
            resultArray.append(result)
            if conditionsArray.count > 0 {
                resultArray.append(conditionsArray.removeFirst())
            } else {
                var finalResult = resultArray.removeFirst() as? Bool ?? false
                while resultArray.count > 0 {
                    let condition: String = resultArray.removeFirst() as? String ?? ""
                    let last = resultArray.removeFirst() as? Bool ?? false
                    if condition == "AND" {
                        finalResult = finalResult && last
                    } else if condition == "OR" {
                        finalResult = finalResult || last
                    }
                }
                return finalResult
            }
        }
    }
    return false
}

func evaluateExpression(conditions: inout [String]) -> Bool {
    let first = conditions.removeFirst()
    let operatorValue = conditions.removeFirst()
    let last = conditions.removeFirst()
    let dFirst = Double(first) ?? 0.0
    let dLast = Double(last) ?? 0.0
    switch operatorValue {
    case "==":
        if dFirst == dLast && dFirst != 0 {
            return true
        }
        return (first == last)
    case "equalTo":
        if dFirst == dLast && dFirst != 0 {
            return true
        }
        return (first == last)
    case ">", "moreThan":
        return dFirst > dLast
    case "<", "lessThan":
        return dFirst < dLast
    case "!=":
        if (dFirst != dLast) && (dFirst != 0 && dFirst != 0) {
            return true
        }
        return (first != last)
    case ">=":
        return dFirst >= dLast
    case "<=":
        return dFirst <= dLast
    case "in":
        let components = last.components(separatedBy: ",")
        return components.contains(first) || components.contains(String(format: "%.0f", dFirst))
    default:
        return false
    }
}

func getVariable(value: String) -> String {
    let updatedValue = value.replacingOccurrences(of: "'", with: "").replacingOccurrences(of: "`", with: "")
    switch updatedValue {
    case "Product.code":
        return kProductCode
    case "Points":
        return kPoints
    case "Gender":
        return kGender
    case "ThisMonth":
        return getDateValue(date: Date(), component: .month)
    case "ThisYear":
        return getDateValue(date: Date(), component: .year)
    case "Today":
        return getDateValue(date: Date(), component: .day)
    case "PurchaseThisMonth":
        return kPurchaseThisMonth
    default:
        if updatedValue.contains("DateofPurchase") {
            return getDateOfPurchaseValue(value: updatedValue)
        }
        if updatedValue.contains("DateOfBirth") {
            return getDateOfBirth(value: updatedValue)
        }
        return updatedValue
    }
}

func getDateOfPurchaseValue(value: String) -> String {
    let updatedValue = value.replacingOccurrences(of: "'", with: "").replacingOccurrences(of: "`", with: "")
    let components = updatedValue.components(separatedBy: ".")
    if components.first == "DateofPurchase" && components.count > 1 {
        switch components.last {
        case "Month":
            return kDateOfPurchase.components(separatedBy: "/")[1]
        case "Year":
            return kDateOfPurchase.components(separatedBy: "/")[2]
        case "Day":
            return kDateOfPurchase.components(separatedBy: "/")[0]
        case "DifferenceInDays":
            return getDateDifference(dateStringValue: kDateOfPurchase, component: .day)
        case "DifferenceInMonths":
            return getDateDifference(dateStringValue: kDateOfPurchase, component: .month)
        case "DifferenceInYears":
            return getDateDifference(dateStringValue: kDateOfPurchase, component: .year)
        default:
            return kDateOfPurchase
        }
    }
    return kDateOfPurchase
}

func getDateOfBirth(value: String) -> String {
    let updatedValue = value.replacingOccurrences(of: "'", with: "").replacingOccurrences(of: "`", with: "")
    let components = updatedValue.components(separatedBy: ".")
    if components.first == "DateOfBirth" && components.count > 1 {
        switch components.last {
        case "Month":
            return kDateOfPurchase.components(separatedBy: "/")[1]
        case "Year":
            return kDateOfPurchase.components(separatedBy: "/")[2]
        case "Day":
            return kDateOfPurchase.components(separatedBy: "/")[0]
        case "Age":
            return getDateDifference(dateStringValue: kDob, component: .year)
        default:
            return kDateOfPurchase
        }
    }
    return kDateOfPurchase
}

func getDateDifference(dateStringValue: String, component: Calendar.Component) -> String {
    let df = DateFormatter()
    df.dateFormat = "dd/MM/yyyy"
    let date = df.date(from: dateStringValue)
    let calendar = Calendar.current
    let components = calendar.dateComponents([component], from: date ?? Date(), to: Date())
    if component == .year {
        return String(format: "%d", components.year ?? 0)
    }
    if component == .month {
        return String(format: "%d", components.month ?? 0)
    }
    if component == .day {
        return String(format: "%d", components.day ?? 0)
    }
    return String(format: "%d", components.year ?? 0)
}

func getDateValue(date: Date, component: Calendar.Component) -> String {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day, .month, .year], from: date)
    if component == .year {
        return String(format: "%d", components.year ?? 0)
    }
    if component == .month {
        return String(format: "%d", components.month ?? 0)
    }
    if component == .day {
        return String(format: "%d", components.day ?? 0)
    }
    return String(format: "%d", components.year ?? 0)
}
